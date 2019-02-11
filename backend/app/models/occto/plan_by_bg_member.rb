# == Schema Information
#
# Table name: occto_plan_by_bg_members
#
#  id           :bigint(8)        not null, primary key
#  plan_id      :bigint(8)
#  bg_member_id :bigint(8)
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Occto::PlanByBgMember < ApplicationRecord
  has_many :plan_detail_demand_values
  has_many :plan_detail_supply_values
  has_many :plan_detail_sale_values
  has_many :plan_detail_values
  belongs_to :plan
  belongs_to :bg_member

  accepts_nested_attributes_for :plan_detail_demand_values
  accepts_nested_attributes_for :plan_detail_supply_values
  accepts_nested_attributes_for :plan_detail_sale_values
end
