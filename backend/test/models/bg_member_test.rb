# == Schema Information
#
# Table name: bg_members
#
#  id                 :bigint(8)        not null, primary key
#  balancing_group_id :bigint(8)
#  company_id         :bigint(8)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class BgMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
