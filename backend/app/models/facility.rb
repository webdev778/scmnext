# == Schema Information
#
# Table name: facilities
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string(255)
#  code                  :string(255)
#  consumer_id           :bigint(8)
#  district_id           :bigint(8)
#  voltage_type_id       :bigint(8)
#  contract_capacity     :string(255)
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
  has_one :supply_point
  has_many :facility_contracts, -> { order(start_date: :desc) }
  has_many :contracts, through: :facility_contracts
  has_many :discount_for_facilities, -> { order(start_date: :desc) }
  belongs_to :district
  belongs_to :consumer
  belongs_to :voltage_type

  # validates :name,
  #   presence: true
  # validates :city,
  #   presence: true

  scope :active_at, ->(date) {
    eager_load(:supply_point)
      .where(["supply_point.supply_start_date <= ?", date])
      .where(["supply_point.supply_end_date is null or supply_point.supply_end_date >= ?", date])
  }

  scope :filter_company_id, ->(company_id) {
    eager_load(:consumer)
      .where("consumers.company_id" => company_id)
  }

  scope :filter_district_id, ->(district_id) {
    where(district_id: district_id)
  }

  scope :get_active_facility, ->(company_id, district_id, date) {
    filter_company_id(company_id)
      .filter_district_id(district_id)
      .active_at(date)
  }

  def is_active_at?(date)
    sels.supply_point.is_active_at?(date)
  end

  def sales_special_discount_rate_at(date)
    discount_for_facility = self.discount_for_facility_at(date)
    discount_for_facility ? discount_for_facility.rate : 0
  end

  def discount_for_facility_at(date)
    discount_for_facilities.find do |discount_for_facility|
      discount_for_facility.start_date <= date
    end
  end
end
