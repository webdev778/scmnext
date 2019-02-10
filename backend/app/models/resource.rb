# == Schema Information
#
# Table name: resources
#
#  id         :bigint(8)        not null, primary key
#  company_id :bigint(8)
#  code       :string(255)      not null
#  type       :string(255)      not null
#  name       :string(255)      not null
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Resource < ApplicationRecord
  belongs_to :balancing_group
  has_many :occto_plan_detail_values, class_name: Occto::PlanDetailValue.to_s
end
