# == Schema Information
#
# Table name: supply_points
#
#  id                 :bigint(8)        not null, primary key
#  number             :string(255)
#  supply_start_date  :date
#  supply_end_date    :date
#  supply_method_type :integer          not null
#  base_power         :integer
#  facility_group_id  :bigint(8)
#  facility_id        :bigint(8)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class SupplyPoint < ApplicationRecord
  before_validation :set_facility_group_id, if: -> { not(self.facility_id.nil?) and self.facility_group_id.nil? }

  has_many :usage_fixed_headers, class_name: Dlt::UsageFixedHeader.to_s, primary_key: :number, foreign_key: :supply_point_number
  belongs_to :facility_group
  belongs_to :facility, required: false # 低圧施設の情報を外部提供受けるケースを想定して必須にはしない

  enum supply_method_type: {
    supply_method_type_all: 1,
    supply_method_type_partial: 2
  }

  validates :number,
            presence: true
  validates :facility_group,
            presence: true
  validates :supply_method_type,
            presence: true
  validates :base_power,
            absence: { unless: -> { supply_method_type_partial? } },
            presence: { if: -> { supply_method_type_partial? } }

  class << self
    #
    # 指定された会社・エリアの供給地点番号情報を供給地点番号をkeyにしたhashで返す
    #
    # @param [Integer] company_id 会社ID
    # @param [Integer] district_id エリアID
    # @return [Hash] 供給地点番号をkey,supply_pointオブジェクトを値とするHash
    def get_map_filter_by_compay_id_and_district_id(company_id, district_id)
      eager_load(:facility_group)
        .where("facility_groups.company_id" => company_id, "facility_groups.district_id" => district_id)
        .map do |supply_point|
        [supply_point.number, supply_point]
      end.to_h
    end
  end

  def is_active_at?(date)
    self.supply_start_date <= date and (self.supply_end_date.nil? or self.supply_end_date >= date)
  end

  private

  def set_facility_group_id
    return if self.facility.nil? || self.facility.consumer.nil?

    capacity = self.facility.contract_capacity
    capacity = capacity.blank? ? "0" : capacity
    capacity = BigDecimal(capacity).round(-1).to_i
    contract = self.facility.contracts.first
    facility_group = FacilityGroup.find_or_initialize_by(
      company_id: self.facility.consumer.company_id,
      district_id: self.facility.district_id,
      contract_id: (contract.nil? ? nil : contract.id),
      voltage_type_id: 99,
      contract_capacity: capacity
    )
    if facility_group.new_record?
      facility_group.name = [
        "低圧",
        facility_group.district.id,
        facility_group.district.name,
        (contract.nil? ? "" : contract.id),
        (contract.nil? ? "" : contract.name),
        facility_group.contract_capacity
      ].join('_')
      facility_group.save
      p facility_group
    end
    self.facility_group_id = facility_group.id
  end
end
