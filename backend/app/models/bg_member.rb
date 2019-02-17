# == Schema Information
#
# Table name: bg_members
#
#  id                 :bigint(8)        not null, primary key
#  balancing_group_id :bigint(8)
#  company_id         :bigint(8)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class BgMember < ApplicationRecord
  has_many :resources
  has_one :resource_jbu
  has_one :resource_jepx_spot
  has_one :resource_jepx_one_hour
  has_many :resource_fits
  has_many :resource_matchings
  belongs_to :balancing_group, inverse_of: :bg_members
  belongs_to :company

  def code
    "#{company.code}#{balancing_group.district.code}"
  end
end
