# == Schema Information
#
# Table name: power_usage_fixeds
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

class PowerUsageFixed < ApplicationRecord

  belongs_to :facility

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
    def import_data(company_id, district_id, date = nil)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?
      supply_point_number_map = Facility
        .filter_company_id(company_id)
        .filter_district_id(district_id)
        .select(:supply_point_number, :id, :supply_start_date, :supply_end_date).inject({}) do |map, facility|
          map[facility.supply_point_number] = facility
          map
        end

      setting.get_xml_object_and_process_high_and_low(:fixed, date) do |doc, voltage_class|
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']
        import_data = jptrm.elements['JPM00010'].to_a.map do |nodes_by_facility|
          next if nodes_by_facility.elements['JP06405'].text != '0'
          supply_point_number = nodes_by_facility.elements['JP06400'].text
          facility = supply_point_number_map[supply_point_number]
          nodes_by_facility.elements['JPM00013'].to_a.map do |nodes_by_day|
            date = Time.strptime(nodes_by_day.elements['JP06423'].text, "%Y%m%d")
            next if facility.nil? || !facility.is_active_at?(date)
            nodes_by_day.elements['JPM00014'].to_a.map do |nodes_by_time|
              {
                date: date,
                time_index_id: nodes_by_time.elements['JP06219'].text,
                facility_id: facility.id,
                value: nodes_by_time.elements['JP06424'].text
              }
            end
          end
        end.flatten.compact
        puts date
        result = self.import import_data, {on_duplicate_key_update: [:date, :time_index_id, :facility_id]}
      end
    end
  end
end
