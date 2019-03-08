# == Schema Information
#
# Table name: district_loss_rates
#
#  id                     :bigint(8)        not null, primary key
#  district_id            :bigint(8)
#  voltage_type_id        :bigint(8)
#  rate                   :float(24)
#  application_start_date :date
#  application_end_date   :date
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class DistrictLossRate < ApplicationRecord
  belongs_to :district_id
  belongs_to :voltage_type

  scope :includes_for_index, lambda {
    includes([:district_id, :voltage_type])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: [:district_id, :voltage_type]
      }
    end
    super options
  end
end
