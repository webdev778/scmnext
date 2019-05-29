# == Schema Information
#
# Table name: bg_member_demand_forecasts
#
#  id            :bigint(8)        not null, primary key
#  bg_member_id  :bigint(8)
#  time_index_id :bigint(8)
#  date          :date
#  demand_value  :decimal(10, 4)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BgMemberDemandForecast < ApplicationRecord
  belongs_to :bg_member
  belongs_to :time_index
end
