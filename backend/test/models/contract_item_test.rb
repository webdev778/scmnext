# == Schema Information
#
# Table name: contract_items
#
#  id                :bigint(8)        not null, primary key
#  name              :string(255)      not null
#  voltage_type_id   :bigint(8)
#  calculation_order :integer
#  enabled           :boolean
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class ContractItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
