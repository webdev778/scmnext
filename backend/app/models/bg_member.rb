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
  has_many :fuel_cost_adjustments
  belongs_to :balancing_group, inverse_of: :bg_members
  belongs_to :company

  scope :includes_for_index, lambda {
    includes([:balancing_group, :company])
  }

  scope :includes_for_list, lambda {
    includes([:company])
  }

  class << self
    def json_option
      {
        include: [:balancing_group, :company]
      }
    end
  end

  def code
    "#{company.code}#{balancing_group.district.code}"
  end

  def name
    company.name.to_s
  end

  #
  # 指定日における電圧クラスごとの燃料調整費データを取得する
  # @param date [Date] 取得する日付
  # @return [Hash] voltage_classをkey,FuelCostAdjustmentのインスタンスを値とするハッシュ
  def fuel_cost_adjustments_at(date)
    fuel_cost_adjustments
      .where(year: date.year, month: date.month)
      .map do |fuel_cost_adjustment|
        [fuel_cost_adjustment.voltage_class, fuel_cost_adjustment]
      end
      .to_h
      .with_indifferent_access
  end

end
