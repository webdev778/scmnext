# == Schema Information
#
# Table name: facilities
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string(255)
#  code                  :string(255)
#  consumer_id           :bigint(8)
#  supply_point_number   :string(255)
#  district_id           :bigint(8)
#  voltage_type_id       :bigint(8)
#  supply_start_date     :date
#  supply_end_date       :date
#  tel                   :string(255)
#  fax                   :string(255)
#  email                 :string(255)
#  url                   :string(255)
#  postral_code          :string(255)
#  pref_no               :integer
#  city                  :string(255)
#  address               :string(255)
#  person_in_charge      :string(255)
#  person_in_charge_kana :string(255)
#  created_by            :integer
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Facility < ApplicationRecord
  belongs_to :district
  belongs_to :consumer
  belongs_to :voltage_type, required: false

  validates :name,
    presence: true
  validates :city,
    presence: true
  validates :supply_point_number,
    presence: true

  scope :active_at, ->(date){
    where(["supply_start_date <= ?", date])
    .where(["supply_end_date is null or supply_end_date >= ?", date])
  }

  scope :filter_company_id, ->(company_id){
    eager_load(:consumer)
    .where("consumers.company_id" => company_id)
  }

  scope :filter_district_id, ->(district_id){
    where(district_id: district_id)
  }

  scope :get_active_facility, ->(company_id, district_id, date){
    filter_company_id(company_id)
    .filter_district_id(district_id)
    .active_at(date)
  }

  def is_active_at?( date )
    self.supply_start_date <= date and (self.supply_end_date.nil? or self.supply_end_date >= date)
  end
end
