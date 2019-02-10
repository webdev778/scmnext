class BgMember < ApplicationRecord
  has_many :resources
  has_one :resource_jbu
  has_one :resource_jepx_spot
  has_one :resource_jepx_one_hour
  has_many :resource_fits
  has_many :resource_matchings
  belongs_to :balancing_group
  belongs_to :company

  def code
    "#{company.code}#{balancing_group.district.code}"
  end
end
