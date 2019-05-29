# == Schema Information
#
# Table name: occto_fit_plan_detail_values
#
#  id                 :bigint(8)        not null, primary key
#  occto_fit_plan_id  :bigint(8)
#  power_generator_id :bigint(8)
#  time_index_id      :bigint(8)
#  value              :decimal(14, )
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class Occto::FitPlanDetailValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
