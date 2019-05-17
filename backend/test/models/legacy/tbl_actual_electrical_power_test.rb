# == Schema Information
#
# Table name: tbl_actual_electrical_power
#
#  customer_id       :integer          default(0), not null, primary key
#  pps_id            :integer
#  district_id       :integer          default(0), not null
#  time              :datetime         not null, primary key
#  power             :integer          default(0), not null
#  power_loss        :integer          default(0), not null
#  except_base_power :integer          default(0)
#  customer_count    :integer          default(1), not null
#

require 'test_helper'

class Legacy::TblActualElectricalPowerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
