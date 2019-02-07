# == Schema Information
#
# Table name: supply_points
#
#  id                :bigint(8)        not null, primary key
#  number            :string(255)
#  supply_start_date :date
#  supply_end_date   :date
#  facility_group_id :bigint(8)
#  facility_id       :bigint(8)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class SupplyPoint < ApplicationRecord
  before_validation :set_facility_group_id, if: ->{!self.facility_id.nil? and self.facility_group_id.nil?}

  belongs_to :facility_group
  belongs_to :facility, required: false # 低圧施設の情報を外部提供受けるケースを想定して必須にはしない

  validates :number,
    presence: true
  validates :facility_group,
    presence: true

  def is_active_at?(date)
    self.supply_start_date <= date and (self.supply_end_date.nil? or self.supply_end_date >= date)
  end

  private
  def set_facility_group_id
    return if self.facility.nil? || self.facility.consumer.nil?
    capacity = self.facility.contract_capacity
    capacity = capacity.blank? ? "0" : capacity
    capacity = BigDecimal(capacity).round(-1).to_i
    contract =  self.facility.contracts.first
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
