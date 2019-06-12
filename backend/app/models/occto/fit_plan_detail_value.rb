# == Schema Information
#
# Table name: occto_fit_plan_detail_values
#
#  id                                   :bigint(8)        not null, primary key
#  fit_plan_by_power_generator_group_id :bigint(8)
#  power_generator_id                   :bigint(8)
#  time_index_id                        :bigint(8)
#  value                                :decimal(14, )
#  created_by                           :integer
#  updated_by                           :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#

class Occto::FitPlanDetailValue < ApplicationRecord
  belongs_to :fit_plan_by_power_generator_group
  belongs_to :power_generator
  belongs_to :time_index
end
