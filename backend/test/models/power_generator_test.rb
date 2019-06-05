# == Schema Information
#
# Table name: power_generators
#
#  id              :bigint(8)        not null, primary key
#  resources_id    :bigint(8)
#  code            :string(5)        not null
#  name            :string(255)      not null
#  contract_number :string(20)
#  supply_max      :integer
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class PowerGeneratorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
