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
      import_from_dlt(company_id, district_id, date)
    end

    private
    def import_from_dlt(company_id, district_id, date)
      [:high, :low].each do |voltage_class|
        Dlt::File.filter_by_filename(:fixed, voltage_class, date).each do |row|
          import_xml(row)
        end
      end
    end

    #
    # 確定データの取り込みを行う
    #
    def import_xml(record)
      logger.info("start dlt fixed data download filename=#{record.content.filename}")
      supply_point_number_map = Facility
        .filter_company_id(record.setting.company_id)
        .filter_district_id(record.setting.district_id)
        .select(:supply_point_number, :id, :supply_start_date, :supply_end_date).inject({}) do |map, facility|
          map[facility.supply_point_number] = facility
          map
        end
      zip_file = Zip::File.open_buffer(record.content.download)
      doc = REXML::Document.new(zip_file.read(zip_file.entries.first.name))
      import_data = []
      supply_point_numbers_not_active = {}
      doc.elements['SBD-MSG/JPMGRP/JPTRM/JPM00010'].elements.each do |node_facility|
        supply_point_number = node_facility.elements['JP06400'].text
        facility = supply_point_number_map[supply_point_number]
        data_existance = node_facility.elements['JP06405'].text == '0'
        unless data_existance
          next
        end
        node_facility.elements['JPM00013'].elements.each do |node_by_day|
          date = Time.strptime(node_by_day.elements['JP06423'].text, "%Y%m%d")
          unless facility && facility.is_active_at?(date)
            supply_point_numbers_not_active[supply_point_number] = facility
            next
          end
          node_by_day.elements['JPM00014'].each do |node_by_time|
            time_index = node_by_time.elements['JP06219'].text
            value = node_by_time.elements['JP06424'].text
            import_data << {
              date: date,
              time_index_id: time_index,
              facility_id: facility.id,
              value: node_by_time.elements['JP06424'].text
            }
          end
        end
      end
      self.import import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_id]
      logger.info("import count=#{import_data.count}.")
    end

  end

end
