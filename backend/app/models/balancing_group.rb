# == Schema Information
#
# Table name: balancing_groups
#
#  id                :bigint(8)        not null, primary key
#  code              :string(5)        not null
#  name              :string(40)       not null
#  district_id       :bigint(8)
#  leader_company_id :bigint(8)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class BalancingGroup < ApplicationRecord
  has_and_belongs_to_many :companies
  has_many :occto_plans, class_name: Occto::Plan.to_s
  belongs_to :district
  belongs_to :leader_company, class_name: Company.to_s

  scope :includes_for_index, ->{
    includes([:district])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: :district
      }
    end
    super options
  end
end
