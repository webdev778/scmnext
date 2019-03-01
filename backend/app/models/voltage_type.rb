# == Schema Information
#
# Table name: voltage_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VoltageType < ApplicationRecord
  has_many :facilities
  has_many :district_loss_rates
  has_many :contracts
  has_many :contract_item_groups
  has_many :contract_items

  VOLTAGE_CLASS_MAPPING = {
    voltage_class_special_high: 1,
    voltage_class_high: 2,
    voltage_class_low: 3
  }

  def to_voltage_mode
    to_voltage_class == 3 ? :low : :high
  end

  def to_voltage_class
    VOLTAGE_CLASS_MAPPING.invert[(id >= 3 ? 3 : id)]
  end
end
