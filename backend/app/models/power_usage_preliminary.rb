# == Schema Information
#
# Table name: power_usage_preliminaries
#
#  id            :bigint(8)        not null, primary key
#  facility_id   :bigint(8)        not null
#  date          :date             not null
#  time_index_id :bigint(8)        not null
#  value         :decimal(10, 4)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class PowerUsagePreliminary < ApplicationRecord
  belongs_to :facility_group

  validates :facility_group_id,
    presence: true
  #validates_associated :facility

  scope :total_by_time_index, ->{
    eager_load(:facility)
    .group(:time_index_id)
    .sum("value")
  }

  scope :total, ->{
    eager_load(:facility)
    .sum("value")
  }

  class << self
    #
    # 当日データの取り込み
    #
    def import_today_data(company_id, district_id, date, time_index = nil)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?
      supply_point_number_map = SupplyPoint.get_map_filter_by_compay_id_and_district_id(company_id, district_id)
      setting.get_xml_object_and_process_high_and_low(:today, date, time_index) do |doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, "%Y%m%d")
        time_index = jptrm.elements['JP06219'].text
        import_data = element_to_arrray_and_filter_empty_node(jptrm.elements['JPM00010']).map do |nodes_by_facility|
          facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index)
        end
        import_data = import_data.flatten.compact.group_by do |item|
          [item[:date], item[:time_index_id], item[:facility_group_id]]
        end.map do |k, values|
          {date: k[0], time_index_id: k[1], facility_group_id: k[2], value: values.sum{|v| v[:value].nil? ? 0 : BigDecimal(v[:value])}}
        end
        result = self.import(import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_group_id])
      end
    end

    #
    # 過去データの取り込み
    #
    def import_past_data(company_id, district_id, date)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?
      supply_point_number_map = SupplyPoint.get_map_filter_by_compay_id_and_district_id(company_id, district_id)

      setting.get_xml_object_and_process_high_and_low(:past, date) do |doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, "%Y%m%d")
        import_data =  element_to_arrray_and_filter_empty_node(jptrm.elements['JPM00010']).map do |nodes_by_times|
          time_index = nodes_by_times.elements['JP06219'].text
          element_to_arrray_and_filter_empty_node(nodes_by_times.elements['JPM00011']).map do |nodes_by_facility|
            facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index)
          end
        end
        import_data = import_data.flatten.compact.group_by do |item|
          [item[:date], item[:time_index_id], item[:facility_group_id]]
        end.map do |k, values|
          {date: k[0], time_index_id: k[1], facility_group_id: k[2], value: values.sum{|v| v[:value].nil? ? 0 : BigDecimal(v[:value])}}
        end
        result = self.import(import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_group_id])
      end
    end


    private
    #
    # 施設ごとの電力使用量のデータをインポート用のフォーマットに変換する
    # (当日・過去ファイルとも最小単位のフォーマットは同一なので兼用する)
    # 施設が見つからないor期間外の場合はnilを返す
    #
    # @params Hash 施設ごとのxmlデータ
    # @params Hash 供給地点特定番号変換テーブル(供給地点特定番号がkey/値がsupply_pointオブジェクト)
    # @params Symbol 電圧区分(:high or :low)
    # @params Date 日付
    # @params Integer 時間枠ID
    #
    def facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index)
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
      value_tag = case voltage_class when :high then "JP06123" when :low then "JP06125" end
      {
        date: date,
        time_index_id: time_index,
        facility_group_id: supply_point.facility_group.id,
        value: nodes_by_facility.elements['JP06122'].text == "0" ? nodes_by_facility.elements[value_tag].text : nil,
      }
    end

    #
    # elementsを取ると空白のみのエレメントが入るので除去する
    # @params Array REXMLのElementの配列
    # @return フィルタ化された配列
    def element_to_arrray_and_filter_empty_node(elements)
      elements.to_a.delete_if do |node|
        node.is_a?(REXML::Text)
      end
    end
  end
end
