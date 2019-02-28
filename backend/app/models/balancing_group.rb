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
  has_many :bg_members, inverse_of: :balancing_group, dependent: :destroy
  has_many :companies, through: :bg_members
  has_many :resources
  has_many :occto_plans, class_name: Occto::Plan.to_s
  belongs_to :district
  belongs_to :leader_company, class_name: Company.to_s

  scope :includes_for_index, lambda {
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
