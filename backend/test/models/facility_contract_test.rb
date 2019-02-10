# == Schema Information
#
# Table name: facility_contracts
#
#  id          :bigint(8)        not null, primary key
#  facility_id :bigint(8)
#  contract_id :bigint(8)
#  start_date  :date
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class FacilityContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
