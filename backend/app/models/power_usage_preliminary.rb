# == Schema Information
#
# Table name: power_usage_preliminaries
#
#  id                   :bigint(8)        not null, primary key
#  facility_id(施設ID)    :bigint(8)
#  date(日付)             :date
#  time_index_id(時間枠ID) :bigint(8)
#  value(使用量(kwh))      :decimal(10, )
#  created_by           :integer
#  updated_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class PowerUsagePreliminary < ApplicationRecord
  belongs_to :facility

  enum state: {
    state_untreated: 0,
    state_complated: 1,
    state_in_progress: 2,
    state_complated_with_error: 3
  }

  scope :filter_company_and_district, ->(company_id, district_id){
    eager_load(facility: [:consumer] )
    .where(
      "consumers.company_id"=>company_id,
      "facilities.district_id"=>district_id
    )
  }

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
    def import_from_dlt(company_id, district_id, date, time_index = nil)
      supply_point_number_map = Facility.get_active_facility(company_id, district_id, date).pluck(:supply_point_number, :id).to_h
      Dlt::File.eager_load([:content_blob, :content_attachment])
        .where(["active_storage_blobs.filename LIKE ?", make_filename_pattern(:high, :today, date, time_index)])
        .each do |row|
          import_today_data_from_dlt_files(:high, row, supply_point_number_map)
        end
      Dlt::File.eager_load([:content_blob, :content_attachment])
        .where(["active_storage_blobs.filename LIKE ?", make_filename_pattern(:low, :today, date, time_index)])
        .each do |row|
          import_today_data_from_dlt_files(:low, row, supply_point_number_map)
        end
    end

    private
    def import_today_data_from_dlt_files(voltage_class, record, supply_point_number_map)
      value_tag = case voltage_class
      when :high
        "JP06123"
      when :low
        "JP06125"
      else
        raise "invalid voltage_class=#{voltage_class}"
      end
      zip_file = Zip::File.open_buffer(record.content.download)
      doc = REXML::Document.new(zip_file.read(zip_file.entries.first.name))
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

    def make_filename_pattern(voltage_class, data_type, date, time_index = nil)
      yyyymmdd = date.strftime("%Y%m%d")
      if time_index.nil?
        time_pattern = '____'
      else
        time_pattern = TimeIndex.to_time_of_day(time_index).strftime("%H%M")
      end
      case
      when( voltage_class == :high and data_type == :today )
        "W40110#{yyyymmdd}#{time_pattern}____.zip"
      when( voltage_class == :high and data_type == :past )
        "W40120#{yyyymmdd}0000____.zip"
      when( voltage_class == :low and data_type == :today )
        "W41110#{yyyymmdd}#{time_pattern}______.zip"
      when( voltage_class == :low and data_type == :past )
        "W41120#{yyyymmdd}0000______.zip"
      end
    end
  end

end
