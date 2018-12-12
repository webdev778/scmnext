# == Schema Information
#
# Table name: power_supply_plans
#
#  id                                :bigint(8)        not null, primary key
#  company_id(PPS ID)                :bigint(8)
#  district_id(エリアID)                :bigint(8)
#  date(日付)                          :date
#  time_index_id(時間枠ID)              :integer
#  supply_type(供給元区分)                :integer
#  value(計画値)                        :integer
#  interchange_company_id(融通先PPS ID) :bigint(8)
#  created_by                        :integer
#  updated_by                        :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class PowerSupplyPlan < ApplicationRecord
  belongs_to :district
  belongs_to :company
  belongs_to :interchange_company, class_name: "Company"
end
