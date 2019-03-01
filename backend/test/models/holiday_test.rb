# == Schema Information
#
# Table name: holidays
#
#  id          :bigint(8)        not null, primary key
#  district_id :bigint(8)
#  date        :string(255)
#  name        :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class HolidayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
