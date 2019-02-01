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
    def import_today_data(company_id, district_id, date, time_index = nil)
      import_from_dlt(:today, company_id, district_id, date, time_index)
    end

    def import_past_data(company_id, district_id, date)
      import_from_dlt(:past, company_id, district_id, date)
    end

    private
    def import_from_dlt(data_type, company_id, district_id, date, time_index = nil)
      supply_point_number_map = Facility.get_active_facility(company_id, district_id, date).pluck(:supply_point_number, :id).to_h
      Dlt::File.filter_by_filename(data_type, :high, date, time_index).each do |row|
        row.process do |row|
          import_xml(data_type, :high, row.content.download, supply_point_number_map)
        end
      end
      Dlt::File.filter_by_filename(data_type, :low, date, time_index).each do |row|
        row.process do |row|
          import_xml(data_type, :low, row.content.download, supply_point_number_map)
        end
      end
    end

    #
    # 当日データの取り込みを行う
    #
    def import_xml(data_type, voltage_class, io, supply_point_number_map)
      zip_file = Zip::File.open_buffer(io)
      doc = REXML::Document.new(zip_file.read(zip_file.entries.first.name))
      case data_type
      when :today
        import_data = import_today_format_xml(voltage_class, doc, supply_point_number_map)
      when :past
        import_data = import_past_format_xml(voltage_class, doc, supply_point_number_map)
      else
        raise "invalid data_type=#{data_type}"
      end
      self.import import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_id]
    end

    def import_today_format_xml(voltage_class, doc, supply_point_number_map)
      value_tag = case voltage_class
      when :high
        "JP06123"
      when :low
        "JP06125"
      else
        raise "invalid voltage_class=#{voltage_class}"
      end
      date =  Time.strptime(doc.elements['SBD-MSG/JPMGRP/JPTRM/JP06116'].text, "%Y%m%d")
      time_index = doc.elements['SBD-MSG/JPMGRP/JPTRM/JP06219'].text
      supply_point_numbers_not_found = []
      nodes = doc.elements['SBD-MSG/JPMGRP/JPTRM/JPM00010'].elements.to_a
      import_data = nodes.delete_if do |node|
        if supply_point_number_map[node.elements['JP06400'].text].nil?
          supply_point_numbers_not_found << node.elements['JP06400'].text
        else
          false
        end
      end.map do |node|
        {
          date: date,
          time_index_id: time_index,
          facility_id: supply_point_number_map[node.elements['JP06400'].text],
          value: node.elements['JP06122'].text == "0" ? node.elements[value_tag].text : nil
        }
      end
      p supply_point_numbers_not_found
      self.import import_data, on_duplicate_key_update: [:date, :time_index_id, :facility_id]
    end

    def import_past_format_xml(voltage_class, io, supply_point_number_map)
      value_tag = case voltage_class
      when :high
        "JP06123"
      when :low
        "JP06125"
      else
        raise "invalid voltage_class=#{voltage_class}"
      end
      date =  Time.strptime(doc.elements['SBD-MSG/JPMGRP/JPTRM/JP06116'].text, "%Y%m%d")
      time_index = doc.elements['SBD-MSG/JPMGRP/JPTRM/JP06219'].text
      supply_point_numbers_not_found = []
      nodes = doc.elements['SBD-MSG/JPMGRP/JPTRM/JPM00010'].elements.to_a
      import_data = nodes.delete_if do |node|
        if supply_point_number_map[node.elements['JP06400'].text].nil?
          supply_point_numbers_not_found << node.elements['JP06400'].text
        else
          false
        end
      end.map do |node|
        {
          date: date,
          time_index_id: time_index,
          facility_id: supply_point_number_map[node.elements['JP06400'].text],
          value: node.elements['JP06122'].text == "0" ? node.elements[value_tag].text : nil
        }
      end
    end

  end

end
