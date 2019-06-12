# == Schema Information
#
# Table name: occto_fit_plan_by_power_generator_groups
#
#  id                       :bigint(8)        not null, primary key
#  fit_plan_id              :bigint(8)
#  power_generator_group_id :bigint(8)
#  created_by               :integer
#  updated_by               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'test_helper'

class Occto::FitPlanByPowerGeneratorGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
