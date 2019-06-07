# == Schema Information
#
# Table name: occto_fit_plan_by_resoures
#
#  id          :bigint(8)        not null, primary key
#  fit_plan_id :bigint(8)
#  resource_id :bigint(8)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Occto::FitPlanByResoure < ApplicationRecord
  has_many :fit_plan_detail_values, dependent: :delete_all

  belongs_to :fit_plan
  belongs_to :resource
end
