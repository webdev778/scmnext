# == Schema Information
#
# Table name: dlt_invalid_supply_points
#
#  id           :bigint(8)        not null, primary key
#  company_id   :bigint(8)
#  district_id  :bigint(8)
#  bg_member_id :bigint(8)
#  number       :string(255)
#  name         :string(255)
#  comment      :string(255)
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class Dlt::InvalidSupplyPointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
