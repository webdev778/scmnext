# == Schema Information
#
# Table name: tbl_actual_electrical_low_power
#
#  customer_id       :integer          default(0), not null, primary key
#  pps_id            :integer
#  district_id       :integer          default(0), not null
#  time              :datetime         not null, primary key
#  power             :float(24)        default(0.0), not null
#  power_loss        :float(24)        default(0.0), not null
#  except_base_power :float(24)        default(0.0)
#

require 'test_helper'

class Legacy::TblActualElectricalLowPowerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
