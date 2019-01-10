class BalancingGroup < ApplicationRecord
  has_and_belongs_to_many :company
  has_many :occto_plans, class_name: Occto::Plan.to_s
  belongs_to :leader_company, class_name: Company.to_s
end
