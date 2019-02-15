# == Schema Information
#
# Table name: facility_groups
#
#  id                :bigint(8)        not null, primary key
#  name              :string(255)      not null
#  company_id        :bigint(8)
#  district_id       :bigint(8)
#  contract_id       :bigint(8)
#  voltage_type_id   :bigint(8)
#  contract_capacity :string(255)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FacilityGroup < ApplicationRecord
  has_many :supply_points
  has_many :facilities, through: :supply_points
  belongs_to :voltage_type
  belongs_to :company
  belongs_to :district
  belongs_to :contract

  def sales_cost_adjustment
    return 0 if self.voltage_type.nil?
    case self.voltage_type.to_voltage_mode
    when :high
      0
    when :low
      -0.43
    end
  end

  def sales_special_discount_rate_at(date)
    return 0 if self.voltage_type.nil?
    case self.voltage_type.to_voltage_mode
    when :high
      self.facility.sales_special_discount_rate_at(date)
    when :low
      0
    end
  end

  def facility
    raise "高圧顧客以外は使用できません。" unless self.voltage_type.to_voltage_mode == :high
    self.facilities.first
  end
end
