# == Schema Information
#
# Table name: power_generator_groups
#
#  id              :bigint(8)        not null, primary key
#  resource_id     :bigint(8)
#  contract_number :string(20)
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class PowerGeneratorGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
