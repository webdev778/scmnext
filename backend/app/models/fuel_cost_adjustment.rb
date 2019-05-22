# == Schema Information
#
# Table name: fuel_cost_adjustments
#
#  id            :bigint(8)        not null, primary key
#  company_id    :bigint(8)
#  district_id   :bigint(8)
#  bg_member_id  :bigint(8)
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
  belongs_to :bg_member

  scope :includes_for_index, lambda {
    includes(bg_member: [:company, {balancing_group: :district}])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include:
        {
          bg_member: {
            include: [
              :company,
              {
                balancing_group: {
                  include: :district
                }
              }
            ]
          }
        }
      }
    end
    super options
  end

  include VoltageClass
end
