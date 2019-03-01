# == Schema Information
#
# Table name: supply_points
#
#  id                 :bigint(8)        not null, primary key
#  number             :string(30)       not null
#  supply_start_date  :date
#  supply_end_date    :date
#  supply_method_type :integer          not null
#  base_power         :integer
#  facility_group_id  :bigint(8)
#  facility_id        :bigint(8)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class SupplyPointTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
