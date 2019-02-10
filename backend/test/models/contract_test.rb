# == Schema Information
#
# Table name: contracts
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string(255)      not null
#  name_for_invoice       :string(255)      not null
#  voltage_type_id        :bigint(8)
#  contract_item_group_id :bigint(8)
#  start_date             :date
#  end_date               :date
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
