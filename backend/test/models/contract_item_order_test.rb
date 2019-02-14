# == Schema Information
#
# Table name: contract_item_orders
#
#  id                     :bigint(8)        not null, primary key
#  contract_item_group_id :bigint(8)
#  contract_item_id       :bigint(8)
#  sort_order             :integer
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class ContractItemOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
