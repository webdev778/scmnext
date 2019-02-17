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
    def import_today_data(company_id, district_id, date, time_index = nil)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?
      supply_point_number_map = SupplyPoint.get_map_filter_by_compay_id_and_district_id(company_id, district_id)
      setting.get_xml_object_and_process_high_and_low(:today, date, time_index) do |file, doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, "%Y%m%d")
        time_index = jptrm.elements['JP06219'].text
        import_data = jptrm.elements['JPM00010'].to_a.map do |nodes_by_facility|
          facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index, setting)
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

      setting.get_xml_object_and_process_high_and_low(:past, date) do |file, doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, "%Y%m%d")
        import_data =  jptrm.elements['JPM00010'].to_a.map do |nodes_by_times|
          time_index = nodes_by_times.elements['JP06219'].text
          nodes_by_times.elements['JPM00011'].to_a.map do |nodes_by_facility|
            facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index, setting.district.is_partial_included)
          end
        end
        import_data = import_data.flatten.compact.group_by do |item|
          [item[:date], item[:time_index_id], item[:facility_group_id]]
        end.map do |k, values|
          {date: k[0], time_index_id: k[1], facility_group_id: k[2], value: values.sum{|v| v[:value].nil? ? 0 : BigDecimal(v[:value])}}
        end
        result = self.import(import_data, on_duplicate_key_update: [:value])
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
      value_tag = case voltage_class when :high then "JP06123" when :low then "JP06125" end
      value = nil
      if nodes_by_facility.elements['JP06122'].text == "0"
        value = BigDecimal(nodes_by_facility.elements[value_tag].text)
        if setting.district.is_partial_included and supply_point.supply_method_type_partial? then
          value = value - (supply_point.base_power / 2)
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
  end
end
