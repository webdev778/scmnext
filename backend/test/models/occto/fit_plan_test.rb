# == Schema Information
#
# Table name: occto_fit_plans
#
#  id                        :bigint(8)        not null, primary key
#  bg_member_id              :bigint(8)
#  date                      :date             not null
#  initialized_at            :datetime
#  received_at               :datetime
#  send_at                   :datetime
#  fit_id_text               :string(23)
#  stat                      :string(1)
#  fit_recept_stat           :string(2)
#  last_update_datetime_text :string(17)
#  created_by                :integer
#  updated_by                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'test_helper'

class Occto::FitPlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
