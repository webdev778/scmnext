# == Schema Information
#
# Table name: occto_plan_by_companies
#
#  id         :bigint(8)        not null, primary key
#  plan_id    :bigint(8)
#  company_id :bigint(8)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Occto::PlanByCompany < ApplicationRecord
  has_many :plan_detail_demand_values
  has_many :plan_detail_supply_values
  has_many :plan_detail_sales_values
  belongs_to :plan
  belongs_to :company
end
