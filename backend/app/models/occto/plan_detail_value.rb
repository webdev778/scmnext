# == Schema Information
#
# Table name: occto_plan_detail_values
#
#  id                   :bigint(8)        not null, primary key
#  type                 :string(30)
#  plan_by_bg_member_id :bigint(8)
#  resource_id          :bigint(8)
#  time_index_id        :bigint(8)
#  value                :decimal(14, )
#  created_by           :integer
#  updated_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Occto::PlanDetailValue < ApplicationRecord
  belongs_to :plan_by_bg_member
  belongs_to :time_index, required: false
end
