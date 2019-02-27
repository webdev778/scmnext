# == Schema Information
#
# Table name: dlt_usage_fixed_headers
#
#  id                      :bigint(8)        not null, primary key
#  file_id                 :bigint(8)
#  supply_point_number     :string(22)       not null
#  consumer_code           :string(21)
#  consumer_name           :string(80)
#  supply_point_name       :string(70)
#  voltage_class_name      :string(4)
#  journal_code            :integer
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
  belongs_to :file
  belongs_to :supply_point, primary_key: :number, foreign_key: :supply_point_number

  accepts_nested_attributes_for :usage_fixed_details

  class << self
    def import_data(company_id, district_id, date = nil)
      setting = Dlt::Setting.find_by(company_id: company_id, district_id: district_id)
      raise "設定情報が見つかりません。[company_id: #{company_id}, district_id: #{district_id}]" if setting.nil?

      setting.get_xml_object_and_process_high_and_low(:fixed, date) do |file, doc, voltage_class|
        logger.info "start import fixed #{date} voltege mode #{voltage_class}"
        self.where(file_id: file.id).destroy_all
        failed_instances = []
        ids = []
        num_create = 0
        jptrm = doc.elements['SBD-MSG/JPMGRP/JPTRM']

        jptrm.elements['JPM00010'].to_a.each do |nodes_by_facility|
          header_attributes = {
            file_id: file.id,
            year: jptrm.elements['JP06401'].text[0, 4],
            month: jptrm.elements['JP06401'].text[4, 2]
          }
          mapping = {
            supply_point_number: { tag: 'JP06400' },
            consumer_code: { tag: 'JP06119' },
            consumer_name: { tag: 'JP06120' },
            supply_point_name: { tag: 'JP06402' },
            voltage_class_name: { tag: 'JP06403' },
            journal_code: { tag: 'JP06404' },
            can_provide: { tag: 'JP06405', filter: ->(v) { v == '0' } },
            usage_all: { tag: 'JP06426' },
            usage: { tag: 'JP06427' },
            power_factor: { tag: 'JP06406' },
            max_power: { tag: 'JP06445' },
            next_meter_reading_date: { tag: 'JP06446', filter: ->(v) { Time.strptime(v, "%Y%m%d") } }
          }
          header_attributes = xml_to_hash(header_attributes, nodes_by_facility, mapping)
          header = self.new(header_attributes)
          if header.save!
            details = nodes_by_facility.elements['JPM00013'].to_a.map do |nodes_by_day|
              date = Time.strptime(nodes_by_day.elements['JP06423'].text, "%Y%m%d")
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
                xml_to_hash(detail_attributes, nodes_by_time, mapping)
              end
            end.flatten
            detail_import_result = Dlt::UsageFixedDetail.import(details)
            if detail_import_result
              num_create += 1
              ids << header.id
            else
              failed_instances = faild_instances + detail_import_result.faild_instances
            end
          else
            failed_instances << header
          end
        end
        # import不可なので、自力でimportの結果オブジェクトを生成する
        ActiveRecord::Import::Result.new(failed_instances, num_create, ids, [])
      end
    end

    private

    def xml_to_hash(hash, node, mapping)
      mapping.each do |attribute_name, config|
        element = node.elements[config[:tag]]
        if element.nil?
          value = nil
        else
          value = node.elements[config[:tag]].text
          if config[:filter]
            value = config[:filter].call(value)
          end
        end
        hash[attribute_name] = value
      end
      hash
    end
  end
end
