# == Schema Information
#
# Table name: occto_plan_detail_values
#
#  id                 :bigint(8)        not null, primary key
#  type               :string(30)
#  resource_id        :bigint(8)
#  plan_by_company_id :bigint(8)
#  value              :decimal(14, )
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Occto::PlanDetailSupplyValue < Occto::PlanDetailValue
end
