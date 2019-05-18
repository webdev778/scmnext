# == Schema Information
#
# Table name: facility_max_demand_powers
#
#  id          :bigint(8)        not null, primary key
#  facility_id :bigint(8)
#  year        :integer          not null
#  month       :integer          not null
#  value       :decimal(5, )
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class FacilityMaxDemandPowerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
