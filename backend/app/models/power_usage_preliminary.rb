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
      target_files = setting.files.filter_force(force).where(data_type: :today, record_date: date, record_time_index_id: time_index)


      process_each_files_to_tmp_and_import_from_tmp_to_power_usage(target_files) do |file|
        jptrm = file.xml_document.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, '%Y%m%d')
        time_index = jptrm.elements['JP06219'].text
        tmp_import_data = jptrm.elements['JPM00010'].to_a.map do |nodes_by_facility|
          facility_node_to_tmp_power_usage_data(nodes_by_facility, file.voltage_mode, date, time_index)
        end
        TmpPowerUsage.import(tmp_import_data, on_duplicate_key_update: [:value])
      end
    end

    #
    # 過去データの取り込み
    #
    def import_past_data(setting, date, force = false)
      target_files = setting.files.filter_force(force).where(data_type: :past, record_date: date)

      process_each_files_to_tmp_and_import_from_tmp_to_power_usage(target_files) do |file|
        jptrm = file.xml_document.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, '%Y%m%d')
        jptrm.elements['JPM00010'].to_a.reduce([]) do |result, nodes_by_times|
          time_index = nodes_by_times.elements['JP06219'].text
          tmp_import_data = nodes_by_times.elements['JPM00011'].to_a.map do |nodes_by_facility|
            facility_node_to_tmp_power_usage_data(nodes_by_facility, file.voltage_mode, date, time_index)
          end
          TmpPowerUsage.import(tmp_import_data, on_duplicate_key_update: [:value])
        end
      end
    end

    private

    #
    # 施設ごとの電力使用量のデータをインポート用のフォーマットに変換する
    # (当日・過去ファイルとも最小単位のフォーマットは同一なので兼用する)
    # 施設が見つからないor期間外の場合はnilを返す
    #
    # @param [Hash] nodes_by_facility 施設ごとのxmlデータ
    # @param [Hash] supply_point_number_map 供給地点特定番号変換テーブル(供給地点特定番号がkey/値がsupply_pointオブジェクト)
    # @param [Symbol] voltage_class 電圧区分(:high or :low)
    # @param [Date] date 日付
    # @param [Integer] time_index 時間枠ID
    #
    def facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index, setting)
      supply_point_number = nodes_by_facility.elements['JP06400'].text
      supply_point = supply_point_number_map[supply_point_number]
      if supply_point.nil?
        logger.error("供給地点特定番号:[#{supply_point_number}]に対応する施設が見つかりません。需要家名=#{nodes_by_facility.elements['JP06120'].text}")
        puts "供給地点特定番号:[#{supply_point_number}]に対応する施設が見つかりません。需要家名=#{nodes_by_facility.elements['JP06120'].text}"
        return nil
      end
      unless supply_point.is_active_at?(date)
        logger.error("供給地点特定番号:[#{supply_point_number}]は契約期間外です。需要家名=#{nodes_by_facility.elements['JP06120'].text}")
        puts "供給地点特定番号:[#{supply_point_number}]は契約期間外です。需要家名=#{nodes_by_facility.elements['JP06120'].text}"
        return nil
      end
      value_tag = case voltage_class when :high then 'JP06123' when :low then 'JP06125' end
      value = nil
      if nodes_by_facility.elements['JP06122'].text == '0'
        value = BigDecimal(nodes_by_facility.elements[value_tag].text)
        if setting.district.is_partial_included && supply_point.supply_metexhod_type_partial?
          value -= (supply_point.base_power / 2)
          value = value >= 0 ? value : 0
        end
      end
      {
        date: date,
        time_index_id: time_index,
        facility_group_id: supply_point.facility_group.id,
        value: value
      }
    end

    def process_each_files_to_tmp_and_import_from_tmp_to_power_usage(target_files)
      init_tmp_power_usage
      begin
        target_files.update_all(state: :state_in_progress)
        target_files.find_each do |file|
          logger.info(file.content.filename.to_s)
          yield file
        end
        if import_from_tmp_to_power_usage
          target_files.update_all(state: :state_complated)
        else
          target_files.update_all(state: :state_complated_with_error)
        end
      rescue
        target_files.update_all(state: :state_exception)
      end
    end

    #
    # 施設ごとの電力使用量のデータをインポート用のフォーマットに変換する
    # (当日・過去ファイルとも最小単位のフォーマットは同一なので兼用する)
    # 施設が見つからないor期間外の場合はnilを返す
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

    #
    # TempPowerUsageに登録されたデータを速報値データとして取り込む
    #
    def import_from_tmp_to_power_usage
      import_data = []
      TmpPowerUsage.joins(:supply_point).distinct.group("supply_points.facility_group_id", "date", "time_index_id").sum("value").each do |keys, value|
        facility_group_id, date, time_index_id = keys
        import_data << {date: date, time_index_id: time_index_id, facility_group_id: facility_group_id, value: value}
      end
      self.import(import_data, on_duplicate_key_update: [:value])
    end
  end
end
