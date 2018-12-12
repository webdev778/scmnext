# == Schema Information
#
# Table name: power_usage_preliminaries
#
#  id                   :bigint(8)        not null, primary key
#  facility_id(施設ID)    :bigint(8)
#  date(日付)             :date
#  time_index_id(時間枠ID) :bigint(8)
#  value(使用量(kwh))      :decimal(10, )
#  created_by           :integer
#  updated_by           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class PowerUsagePreliminary < ApplicationRecord
  belongs_to :facility

  scope :filter_company_and_district, ->(company_id, district_id){
    eager_load(facility: [:consumer] )
    .where(
      "consumers.company_id"=>company_id,
      "facilities.district_id"=>district_id
    )
  }

  scope :total_by_time_index, ->{
    eager_load(:facility)
    .group(:time_index_id)
    .sum("value")
  }

  scope :total, ->{
    eager_load(:facility)
    .sum("value")
  }
end
