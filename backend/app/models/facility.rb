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
#  postal_code           :string(255)
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

  scope :active_at, lambda { |date|
    eager_load(:supply_point)
      .where(['supply_point.supply_start_date <= ?', date])
      .where(['supply_point.supply_end_date is null or supply_point.supply_end_date >= ?', date])
  }

  scope :filter_company_id, lambda { |company_id|
    eager_load(:consumer)
      .where('consumers.company_id' => company_id)
  }

  scope :filter_district_id, lambda { |district_id|
    where(district_id: district_id)
  }

  scope :get_active_facility, lambda { |company_id, district_id, date|
    filter_company_id(company_id)
      .filter_district_id(district_id)
      .active_at(date)
  }

  scope :includes_for_index, lambda {
    includes([
               { consumer: :company },
               :district,
               :supply_point
             ])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: [
          { consumer: {
            include: :company
          } },
          :district,
          :supply_point,
          :facility_contracts
        ]
      }
    end
    super options
  end

  def is_active_at?(date)
    sels.supply_point.is_active_at?(date)
  end

  def sales_special_discount_rate_at(date)
    discount_for_facility = discount_for_facility_at(date)
    discount_for_facility ? discount_for_facility.rate : 0
  end

  def discount_for_facility_at(date)
    discount_for_facilities.find do |discount_for_facility|
      discount_for_facility.start_date <= date
    end
  end

  # 設備グループ用の名称を返す
  def name_for_facility_group
    contract = contracts.first
    [
      '低圧',
      district.id,
      district.name,
      (contract.nil? ? '' : contract.id),
      (contract.nil? ? '' : contract.name),
      contract_capacity_for_facility_group
    ].join('_')
  end

  # 低圧の設備グループ用の契約容量(10の位で丸めた数字)を返す
  # (値が取れない場合は0とする)
  def contract_capacity_for_facility_group
    if contract_capacity.presence
      BigDecimal(contract_capacity).round(-1).to_i
    else
      0
    end
  end
end
