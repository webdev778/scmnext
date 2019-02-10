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
  belongs_to :facility_group

  validates :facility_group_id,
    presence: true

  scope :total_by_time_index, ->{
    eager_load(:facility_group)
    .group(:time_index_id)
    .sum("value")
  }

  scope :total, ->{
    eager_load(:facility_group)
    .sum("value")
  }

  class << self
    def import_data(company_id, district_id, date = nil)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?
      supply_point_number_map = SupplyPoint.get_map_filter_by_compay_id_and_district_id(company_id, district_id)

      setting.get_xml_object_and_process_high_and_low(:fixed, date) do |doc, voltage_class|
        import_data = jptrm.elements['JPM00010'].to_a.map do |nodes_by_facility|
          next if nodes_by_facility.elements['JP06405'].text != '0'
          supply_point_number = nodes_by_facility.elements['JP06400'].text
          supply_point = supply_point_number_map[supply_point_number]
          if supply_point.nil?
            logger.error("供給地点特定番号:[#{supply_point_number}]に対応する施設が見つかりません。需要家名=#{nodes_by_facility.elements['JP06120'].text}")
            puts "供給地点特定番号:[#{supply_point_number}]に対応する施設が見つかりません。需要家名=#{nodes_by_facility.elements['JP06120'].text}"
            next
          end
          nodes_by_facility.elements['JPM00013'].to_a.map do |nodes_by_day|
            date = Time.strptime(nodes_by_day.elements['JP06423'].text, "%Y%m%d")
            unless supply_point.is_active_at?(date)
              logger.error("供給地点特定番号:[#{supply_point_number}]は契約期間外です。需要家名=#{nodes_by_facility.elements['JP06120'].text}")
              puts "供給地点特定番号:[#{supply_point_number}]は契約期間外です。需要家名=#{nodes_by_facility.elements['JP06120'].text}"
              next
            end
            value = BigDecimal(nodes_by_time.elements['JP06424'].text)
            if setting.district.is_partial_included and supply_point.supply_method_type_partial? then
              value = value - (supply_point.base_power / 2)
              value = value >= 0 ? value : 0
            end
            nodes_by_day.elements['JPM00014'].to_a.map do |nodes_by_time|
              {
                date: date,
                time_index_id: nodes_by_time.elements['JP06219'].text,
                facility_group_id: supply_point.facility_group.id,
                value: value
              }
            end
          end
        end
        import_data = import_data.flatten.compact.group_by do |item|
          [item[:date], item[:time_index_id], item[:facility_group_id]]
        end.map do |k, values|
          {date: k[0], time_index_id: k[1], facility_group_id: k[2], value: values.sum{|v| v[:value].nil? ? 0 : BigDecimal(v[:value])}}
        end
        result = self.import import_data, {on_duplicate_key_update: [:value]}
      end
    end
  end
end
