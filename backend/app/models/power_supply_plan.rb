# == Schema Information
#
# Table name: power_supply_plans
#
#  id                     :bigint(8)        not null, primary key
#  company_id             :bigint(8)
#  district_id            :bigint(8)
#  date                   :date
#  time_index_id          :integer
#  supply_type            :integer
#  value                  :integer
#  interchange_company_id :bigint(8)
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class PowerSupplyPlan < ApplicationRecord
  belongs_to :district
  belongs_to :company
  belongs_to :interchange_company, class_name: "Company"
end
