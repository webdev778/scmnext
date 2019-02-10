# == Schema Information
#
# Table name: fuel_cost_adjustments
#
#  id            :bigint(8)        not null, primary key
#  district_id   :bigint(8)
#  year          :integer          not null
#  month         :integer          not null
#  voltage_class :integer          not null
#  unit_price    :decimal(10, 4)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FuelCostAdjustment < ApplicationRecord
  include VoltageClass
end
