# == Schema Information
#
# Table name: occto_plans
#
#  id                 :bigint(8)        not null, primary key
#  balancing_group_id :bigint(8)
#  district_id        :bigint(8)
#  date               :date             not null
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Occto::Plan < ApplicationRecord
  belongs_to :balancing_group
  has_many :plan_by_companies
end
