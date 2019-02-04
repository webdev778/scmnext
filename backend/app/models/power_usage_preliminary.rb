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
  belongs_to :facility

  validates :facility_id,
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

      supply_point_number_map = Facility.get_active_facility(company_id, district_id, date).pluck(:supply_point_number, :id).to_h

      setting.get_xml_object_and_process_high_and_low(:past, date) do |doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, "%Y%m%d")
        time_index = jptrm.elements['JP06219'].text
        import_data = jptrm.elements['JPM00010'].to_a.map do |key, nodes_by_facility|
          facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index)
        end
        logger.debug(import_data)
        result = self.import(import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_id])
      end
    end

    #
    # 過去データの取り込み
    #
    def import_past_data(company_id, district_id, date)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?

      supply_point_number_map = Facility.get_active_facility(company_id, district_id, date).pluck(:supply_point_number, :id).to_h

      setting.get_xml_object_and_process_high_and_low(:past, date) do |doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        date =  Time.strptime(jptrm.elements['JP06116'].text, "%Y%m%d")
        import_data =  jptrm.elements['JPM00010'].to_a
        .delete_if do |node|
          # 空白が入るケースがあるので対処
          node.is_a?(REXML::Text)
        end.map do |nodes_by_times|
          time_index = nodes_by_times.elements['JP06219'].text
          nodes_by_times.elements['JPM00011'].to_a
          .delete_if do |node|
            # 空白が入るケースがあるので対処
            node.is_a?(REXML::Text)
          end.map do |nodes_by_facility|
            facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index)
          end
        end.flatten
        logger.debug(import_data)
        result = self.import(import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_id])
      end
    end


    private
    #
    # 施設ごとの電力使用量のデータをインポート用のフォーマットに変換する
    # (当日・過去ファイルとも最小単位のフォーマットは同一なので兼用する)
    #
    # @params Hash 施設ごとのxmlデータ
    # @params Hash 供給地点特定番号変換テーブル(供給地点特定番号がkey/値が施設ID)
    # @params Symbol 電圧区分(:high or :low)
    # @params Date 日付
    # @params Integer 時間枠ID
    #
    def facility_node_to_import_data(nodes_by_facility, supply_point_number_map, voltage_class, date, time_index)
      value_tag = case voltage_class when :high then "JP06123" when :low then "JP06125" end
      {
        date: date,
        time_index_id: time_index,
        facility_id: supply_point_number_map[nodes_by_facility.elements['JP06400'].text],
        value: nodes_by_facility.elements['JP06122'].text == "0" ? nodes_by_facility.elements[value_tag].text : nil,
      }
    end
  end
end
