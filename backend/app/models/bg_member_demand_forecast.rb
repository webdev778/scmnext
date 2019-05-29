class BgMemberDemandForecast < ApplicationRecord
  belongs_to :bg_member
  belongs_to :time_index
end
