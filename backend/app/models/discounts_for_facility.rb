# == Schema Information
#
# Table name: discounts_for_facilities
#
#  id          :bigint(8)        not null, primary key
#  facility_id :bigint(8)
#  start_date  :date             not null
#  rate        :decimal(10, 4)   not null
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DiscountsForFacility < ApplicationRecord
  belongs_to :facility

  scope :includes_for_index, lambda {
    includes([:facility])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: :facility
      }
    end
    super options
  end
end
