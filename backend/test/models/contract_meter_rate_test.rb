# == Schema Information
#
# Table name: contract_meter_rates
#
#  id               :bigint(8)        not null, primary key
#  contract_id      :bigint(8)
#  contract_item_id :bigint(8)
#  start_date       :date
#  end_date         :date
#  rate             :decimal(10, 4)
#  created_by       :integer
#  updated_by       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class ContractMeterRateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
