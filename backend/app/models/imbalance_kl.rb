# == Schema Information
#
# Table name: imbalance_kls
#
#  id          :bigint(8)        not null, primary key
#  district_id :bigint(8)
#  start_date  :date
#  k_value     :decimal(10, 4)
#  l_value     :decimal(10, 4)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ImbalanceKl < ApplicationRecord
  belongs_to :district

  scope :includes_for_index, lambda {
    includes(:district)
  }

  validates :k_value,
    numericality: {presence: true}

  validates :l_value,
    numericality: {presence: true}

  def as_json(options = {})
    if options.blank?
      options = {
        include: :district
      }
    end
    super options
  end
end
