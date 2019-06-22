# == Schema Information
#
# Table name: dlt_invalid_supply_points
#
#  id           :bigint(8)        not null, primary key
#  company_id   :bigint(8)
#  district_id  :bigint(8)
#  bg_member_id :bigint(8)
#  number       :string(255)
#  name         :string(255)
#  comment      :string(255)
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Dlt::InvalidSupplyPoint < ApplicationRecord
  # don't use this relation.
  # belongs_to :company
  # belongs_to :district
  belongs_to :bg_member

  scope :includes_for_index, lambda {
    includes(bg_member: [:company, {balancing_group: :district}])
  }

  class << self
    def json_option
      {
        include: {
          bg_member: {
            include:
              [
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
  end

end
