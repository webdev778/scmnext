# == Schema Information
#
# Table name: dlt_usage_fixed_headers
#
#  id                      :bigint(8)        not null, primary key
#  facility_group_id       :bigint(8)
#  information_type_code   :string(4)        not null
#  year                    :integer          not null
#  month                   :integer          not null
#  record_date             :date             not null
#  sender_code             :string(5)        not null
#  receiver_code           :string(5)        not null
#  supply_point_number     :string(22)       not null
#  consumer_code           :string(21)
#  consumer_name           :string(80)
#  supply_point_name       :string(70)
#  voltage_class_name      :string(4)
#  journal_code            :string(1)
#  can_provide             :boolean
#  usage_all               :decimal(10, 4)
#  usage                   :decimal(10, 4)
#  power_factor            :decimal(10, 4)
#  max_power               :decimal(10, 4)
#  next_meter_reading_date :date
#  created_by              :integer
#  updated_by              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Dlt::UsageFixedHeader < ApplicationRecord
  has_many :usage_fixed_details, dependent: :delete_all
  belongs_to :supply_point, primary_key: :number, foreign_key: :supply_point_number, required: false

  accepts_nested_attributes_for :usage_fixed_details

  class_attribute :supply_points_map

  #
  # 供給地点特定番号に対応する施設グループIDをセットする
  #
  def set_facility_group_id!
    supply_points = self.class.get_supply_points_map[supply_point_number]
    case
    when supply_points.nil?
      logger.warn "#{supply_point_number}は未登録"
    when supply_points.count == 1
      update(facility_group_id: supply_points[0].facility_group_id)
    else
      active_supply_points = supply_points.select{|supply_point| supply_point.is_active_at?(record_date)}
      if active_supply_points.count >= 1
        logger.warn "#{supply_point_number}に対応する供給地点が複数存在" if active_supply_points.count > 1
        update(facility_group_id: active_supply_points[0].facility_group_id)
      else
        logger.warn "#{supply_point_number}の供給日指定に不整合あり"
        update(facility_group_id: supply_points[0].facility_group_id)
      end
    end
  end

  class << self
    #
    # インポート処理を行う
    #
    def import_data(setting, date, force)
      target_name = "#{setting.bg_member.company.name} #{setting.bg_member.balancing_group.district.name}"
      logger.info("[#{target_name}]の確定使用量データの取り込み処理を開始")

      [:high, :low].each do |voltage_mode|
        target_files = setting.files.filter_force(force).where(data_type: :fixed, voltage_mode: voltage_mode, record_date: date).order(revision: :asc, section_number: :asc)
        # ActiveRecordRelation Objectで検索条件に含まれているステータスの変更をブロック内で行っているため
        # 思わぬ動作をしてしまうので、最初に配列にしておく
        # @todo ここの処理、models/power_usage_preliminary.rbのprocess_each_files_to_tmp_and_import_from_tmp_to_power_usageとほぼ同じなので、共通化する余地あり
        file_ids = target_files.pluck(:id)
        file_list = target_files.to_a
        # エラー時に現在処理中のfile_idをセットする
        current_file_id = nil
        begin
          # 処理以前に作成されたデータを削除する
          Dlt::File.where(id: file_ids).update_all(state: :state_in_progress)
          file_list.each do |file|
            current_file_id = file.id
            logger.info("#{file.content.filename.to_s}:読込")
            process_each_file file, date
          end
          Dlt::File.where(id: file_ids).update_all(state: :state_complated)
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
    end

    #
    # 供給地点特定番号をkey、それに対応するSupplyPointのインスタンスをvalueとするハッシュを返す
    #
    def get_supply_points_map
      self.supply_points_map ||= SupplyPoint.all.group_by{|supply_point| supply_point.number}
    end

    private
    def process_each_file(file, record_date)
      jptrm = file.xml_document.elements['SBD-MSG/JPMGRP/JPTRM']
      jptrm.elements['JPM00010'].to_a.each do |nodes_by_facility|
        key_attributes = {
          information_type_code: jptrm.elements['JP00002'].text,
          sender_code: jptrm.elements['JP06110'].text,
          receiver_code: jptrm.elements['JP06112'].text,
          year: jptrm.elements['JP06401'].text[0, 4],
          month: jptrm.elements['JP06401'].text[4, 2]
        }
        key_mapping = {
          supply_point_number: { tag: 'JP06400' },
          journal_code: { tag: 'JP06404' }
        }
        key_attributes = set_values_from_xml(key_attributes, nodes_by_facility, key_mapping)
        header = find_or_initialize_by(key_attributes)
        header_mapping = {
          consumer_code: { tag: 'JP06119' },
          consumer_name: { tag: 'JP06120' },
          supply_point_name: { tag: 'JP06402' },
          voltage_class_name: { tag: 'JP06403' },
          can_provide: { tag: 'JP06405', filter: ->(v) { v == '0' } },
          usage_all: { tag: 'JP06426' },
          usage: { tag: 'JP06427' },
          power_factor: { tag: 'JP06406' },
          max_power: { tag: 'JP06445' },
          next_meter_reading_date: { tag: 'JP06446', filter: ->(v) { Time.strptime(v, '%Y%m%d') } }
        }
        header = set_values_from_xml(header, nodes_by_facility, header_mapping)
        header.record_date = record_date
        header.set_facility_group_id!
        header.save!
        details = nodes_by_facility.elements['JPM00013'].to_a.map do |nodes_by_day|
          date = Time.strptime(nodes_by_day.elements['JP06423'].text, '%Y%m%d')
          nodes_by_day.elements['JPM00014'].to_a.map do |nodes_by_time|
            detail_attributes = {
              usage_fixed_header_id: header.id,
              date: date
            }
            mapping = {
              time_index_id: { tag: 'JP06219' },
              usage_all: { tag: 'JP06424' },
              usage: { tag: 'JP06425' }
            }
            set_values_from_xml(detail_attributes, nodes_by_time, mapping)
          end
        end.flatten
        Dlt::UsageFixedDetail.where(usage_fixed_header_id: header.id).delete_all
        Dlt::UsageFixedDetail.import(details, validate: false)
      end
    end

    def set_values_from_xml(hash, node, mapping)
      mapping.each do |attribute_name, config|
        element = node.elements[config[:tag]]
        if element.nil?
          value = nil
        else
          value = node.elements[config[:tag]].text
          value = config[:filter].call(value) if config[:filter]
        end
        hash[attribute_name] = value
      end
      hash
    end
  end
end
