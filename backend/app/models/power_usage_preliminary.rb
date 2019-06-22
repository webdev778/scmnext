# == Schema Information
#
# Table name: power_usage_preliminaries
#
#  id                :bigint(8)        not null, primary key
#  facility_group_id :bigint(8)        not null
#  date              :date             not null
#  time_index_id     :bigint(8)        not null
#  value             :decimal(10, 4)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class PowerUsagePreliminary < ApplicationRecord
  include PowerUsage

  class << self
    #
    # 当日データの取り込み
    #
    def import_today_data(setting, date, time_index, force = false)
      target_name = "#{setting.bg_member.company.name} #{setting.bg_member.balancing_group.district.name}"
      logger.info("[#{target_name}]の速報値当日データ取込処理を開始 (記録日:#{date} コマ:#{time_index})")
      [:high, :low].each do |voltage_mode|
        target_files = setting.files.filter_force(force).where(data_type: :today, voltage_mode: voltage_mode, record_date: date, record_time_index_id: time_index)
        process_each_files_to_tmp_and_import_from_tmp_to_power_usage(target_files, setting, date) do |file|
          today_xml_importer(file)
        end
      end
    end

    #
    # 過去データの取り込み
    #
    def import_past_data(setting, date, force = false)
      target_name = "#{setting.bg_member.company.name} #{setting.bg_member.balancing_group.district.name}"
      logger.info("[#{target_name}]の速報値過去データ取込処理を開始 (記録日:#{date})")
      [:high, :low].each do |voltage_mode|
        target_files = setting.files.filter_force(force).where(data_type: :past, voltage_mode: voltage_mode, record_date: date).order(revision: :asc, section_number: :asc)
        process_each_files_to_tmp_and_import_from_tmp_to_power_usage(target_files, setting, date) do |file|
          past_xml_importer(file)
        end
      end
    end

    private
    def process_each_files_to_tmp_and_import_from_tmp_to_power_usage(target_files, setting, date)
      init_tmp_power_usage
      # ActiveRecordRelation Objectで検索条件に含まれているステータスの変更をブロック内で行っているため
      # 思わぬ動作をしてしまうので、最初に配列にしておく
      # @todo ここの処理、model/dlt/usage_fixed_header.rbのimport_dataとほぼ同じなので、共通化する余地あり
      file_ids = target_files.pluck(:id)
      file_list = target_files.to_a
      # エラー時に現在処理中のfile_idをセットする
      current_file_id = nil
      begin
        Dlt::File.where(id: file_ids).update_all(state: :state_in_progress)
        file_list.each do |file|
          logger.info("#{file.content.filename.to_s}:読込")
          yield file
        end
        if import_from_tmp_to_power_usage(setting)
          Dlt::File.where(id: file_ids).update_all(state: :state_complated)
          Dlt::File.where(data_type: :today, record_date: date).update_all(state: "state_complated")
        else
          Dlt::File.where(id: file_ids).update_all(state: :state_complated_with_error)
        end
      rescue Zip::Error => ex
        logger.error(ex)
        exception_file_ids = file_ids.delete_if{|id| id==current_file_id}
        Dlt::File.where(id: file_ids).update_all(state: :state_exception) unless exception_file_ids.empty?
        Dlt::File.where(id: current_file_id).update_all(state: :state_corrupted)
        raise $!
      rescue Exception => ex
        logger.error(ex)
        Dlt::File.where(id: file_ids).update_all(state: :state_exception)
        raise $!
      end
    end

    #
    # 施設ごとの電力使用量のデータをインポート用のフォーマットに変換する
    # (当日・過去ファイルとも最小単位のフォーマットは同一なので兼用する)
    #
    # @param [Hash] nodes_by_facility 施設ごとのxmlデータ
    # @param [Symbol] voltage_mode 電圧区分(:high or :low)
    # @param [Date] date 日付
    # @param [Integer] time_index 時間枠ID
    #
    def facility_node_to_tmp_power_usage_data(nodes_by_facility, voltage_mode, date, time_index)
      value_tag = case voltage_mode.to_sym when :high then 'JP06123' when :low then 'JP06125' else raise "unknown voltage_mode #{voltage_mode}" end
      value = nil
      if nodes_by_facility.elements['JP06122'].text == '0'
        value = BigDecimal(nodes_by_facility.elements[value_tag].text)
      else
        value = nil
      end
      {
        date: date,
        time_index_id: time_index,
        supply_point_number: nodes_by_facility.elements['JP06400'].text,
        name: (nodes_by_facility.elements['JP06120'].nil? ? nil : nodes_by_facility.elements['JP06120'].text),
        control_number: nodes_by_facility.elements['JP06121'].text,
        value: value
      }
    end

    #
    # インポート用にテンポラリテーブルTempPowerUsageを作成し、ActiveRecordとして使えるようにする
    #
    def init_tmp_power_usage
      ActiveRecord::Base.connection.create_table('tmp_power_usages', temporary: true, force: true) do |t|
        t.date "date", null: false
        t.integer "time_index_id", null: false, limit: 2
        t.string "supply_point_number", null: false, limit: 22
        t.string "control_number", limit: 16
        t.string "name"
        t.decimal "value", precision: 10, scale: 4
        t.index [:date, :time_index_id, :supply_point_number, :control_number], name: :unique_index_for_business, unique: true
      end
      unless Object.const_defined? ('TmpPowerUsage')
        klass = Class.new(ActiveRecord::Base) do |c|
          c.table_name = 'tmp_power_usages'
          c.belongs_to :supply_point, primary_key: :number, foreign_key: :supply_point_number, required: false
        end
        Object.const_set('TmpPowerUsage', klass)
      end
    end

    def today_xml_importer(file)
      jptrm = file.xml_document.elements['SBD-MSG/JPMGRP/JPTRM']
      date =  Time.strptime(jptrm.elements['JP06116'].text, '%Y%m%d')
      time_index = jptrm.elements['JP06219'].text
      tmp_import_data = jptrm.elements['JPM00010'].to_a.map do |nodes_by_facility|
        facility_node_to_tmp_power_usage_data(nodes_by_facility, file.voltage_mode, date, time_index)
      end
      TmpPowerUsage.import(tmp_import_data, validate: false, on_duplicate_key_update: [:value])
    end

    def past_xml_importer(file)
      jptrm = file.xml_document.elements['SBD-MSG/JPMGRP/JPTRM']
      date =  Time.strptime(jptrm.elements['JP06116'].text, '%Y%m%d')
      jptrm.elements['JPM00010'].to_a.reduce([]) do |result, nodes_by_times|
        time_index = nodes_by_times.elements['JP06219'].text
        tmp_import_data = nodes_by_times.elements['JPM00011'].to_a.map do |nodes_by_facility|
          facility_node_to_tmp_power_usage_data(nodes_by_facility, file.voltage_mode, date, time_index)
        end
        TmpPowerUsage.import(tmp_import_data, validate: false, on_duplicate_key_update: [:value])
      end
  end

    #
    # TempPowerUsageに登録されたデータを速報値データとして取り込む
    # また、合わせて供給地点特定番号がない顧客を洗い出し、不整合供給地点に登録する
    #
    def import_from_tmp_to_power_usage(setting)
      invalid_data = []
      TmpPowerUsage
        .left_joins(:supply_point)
        .where("supply_points.id"=>nil)
        .select(:supply_point_number, :name)
        .distinct
        .all
        .each do |tmp_power_usage|
          invalid_data << {
            company_id: setting.bg_member.company_id,
            district_id: setting.bg_member.balancing_group.district_id,
            bg_member_id: setting.bg_member_id,
            number: tmp_power_usage.supply_point_number,
            name: tmp_power_usage.name,
            comment: "供給地点番号未登録"
          }
        end
      TmpPowerUsage
        .joins(:supply_point)
        .where("supply_points.facility_group_id"=>nil)
        .select(:supply_point_number, :name)
        .distinct
        .all
        .each do |tmp_power_usage|
          invalid_data << {
            company_id: setting.bg_member.company_id,
            district_id: setting.bg_member.balancing_group.district_id,
            bg_member_id: setting.bg_member_id,
            number: tmp_power_usage.supply_point_number,
            name: tmp_power_usage.name,
            comment: "低圧グループ未登録"
          }
        end
      Dlt::InvalidSupplyPoint.import(invalid_data, validate: false, on_duplicate_key_update: [:name, :comment])

      import_data = []
      # logger.debug "7657のデータダンプ"
      # TmpPowerUsage
      #   .joins(:supply_point)
      #   .distinct
      #   .where("supply_points.facility_group_id"=>7657).find_each do |row|
      #     logger.debug row.to_json
      #   end

      TmpPowerUsage
        .joins(:supply_point)
        .distinct
        .group("supply_points.facility_group_id", "supply_points.supply_method_type", "supply_points.base_power", "date", "time_index_id")
        .where.not("supply_points.facility_group_id"=>nil)
        .sum("value")
        .each do |keys, value|
          facility_group_id, supply_method_type, base_power, date, time_index_id = keys
          if setting.bg_member.balancing_group.district.is_partial_included &&  SupplyPoint.supply_method_types.invert[supply_method_type] == "supply_method_type_partial"
            value -= (base_power / 2)
            value = value >= 0 ? value : 0
          end
          # if facility_group_id == 7657
          #   logger.debug "7657のデータあり"
          #   logger.debug date: date, time_index_id: time_index_id, facility_group_id: facility_group_id, value: value.to_f
          # end
          import_data << {date: date, time_index_id: time_index_id, facility_group_id: facility_group_id, value: value}
        end
      self.import(import_data, validate: false, on_duplicate_key_update: [:value])
    end
  end
end
