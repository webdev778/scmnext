# == Schema Information
#
# Table name: contract_basic_charges
#
#  id          :bigint(8)        not null, primary key
#  contract_id :bigint(8)
#  start_date  :date             not null
#  rate        :decimal(10, 4)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ContractBasicChargeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
