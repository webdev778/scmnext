# == Schema Information
#
# Table name: jbu_contracts
#
#  id                                      :bigint(8)        not null, primary key
#  resource_id                             :bigint(8)
#  district_id                             :bigint(8)
#  company_id                              :bigint(8)
#  start_date                              :date
#  end_date                                :date
#  contract_power                          :integer
#  basic_charge                            :decimal(10, 4)
#  meter_rate_charge_summer_season_daytime :decimal(10, 4)
#  meter_rate_charge_other_season_daytime  :decimal(10, 4)
#  meter_rate_charge_night                 :decimal(10, 4)
#  meter_rate_charge_peak_time             :decimal(10, 4)
#  fuel_cost_adjustment_charge             :decimal(10, 4)
#  created_by                              :integer
#  updated_by                              :integer
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#

class JbuContract < ApplicationRecord
  # don't use this relation.
  # belongs_to :company
  # belongs_to :district
  belongs_to :resource, inverse_of: :jbu_contracts, class_name: ResourceJbu.to_s

  scope :includes_for_index, lambda {
    includes(resource: {bg_member: [:company, {balancing_group: :district}]})
  }

  class << self
    def json_option
      {
        include: {
          resource: {
            include: {
              bg_member: {
                include: [
                  :company,
                  {
                    balancing_group: {
                      include: :district
                    }
                  }
                ]
              }
            }
          }
        }
      }
    end
  end

  #
  # 基本料
  #
  # @return 契約電力 x 基本料率
  def basic_amount
    contract_power * basic_charge
  end

  #
  # パラメータで指定された日付及び時間枠IDにおける従量料金単価を取得する
  #
  # @param date [Date] 日付
  # @param time_index_id [Integer] 時間枠ID
  # @return [Decimal] 指定日時の従量料金単価
  def meter_rate_charge(date, time_index_id)
    if Holiday.get_list(bg_member.balancing_group.district_id).include?(date)
      result = meter_rate_charge_night
    elsif in_summer_season(date)
      case
      when in_peaktime(time_index_id)
        result = meter_rate_charge_peak_time
      when in_daytime(time_index_id)
        result = meter_rate_charge_summer_season_daytime
      else
        result = meter_rate_charge_night
      end
    else
      case
      when in_daytime(time_index_id)
        result = meter_rate_charge_other_season_daytime
      else
        result = meter_rate_charge_night
      end
    end
    result ||= 0
  end

  private

  #
  # 指定日が休日か否か
  # @param date [Date] チェック対象の日付
  # @return [Boolean] 休日の場合真を返す
  def is_holiday(date)
    Holiday.get_list(bg_member.balancing_group.district_id).include?(date)
  end

  #
  # 指定日が夏季に含まれるか
  # @param date [Date] チェック対象の日付
  # @return [Boolean] 夏季に含まれる場合真を返す
  def in_summer_season(date)
    (bg_member.balancing_group.district.summer_season_start_month..bg_member.balancing_group.district.summer_season_end_month).include?(date.month)
  end

  #
  # 指定の時間枠IDがピークタイムに含まれるか
  # @param time_index_id [Integer] チェック対象の時間枠ID
  # @return [Boolean] ピークタイムに含まれる場合真を返す
  def in_peaktime(time_index_id)
    (bg_member.balancing_group.district.peaktime_start_time_index_id..bg_member.balancing_group.district.peaktime_end_time_index_id).include?(time_index_id)
  end

  #
  # 指定の時間枠IDが昼間時間に含まれるか
  # @param time_index_id [Integer] チェック対象の時間枠ID
  # @return [Boolean] 昼間時間に含まれる場合真を返す
  def in_daytime(time_index_id)
    (bg_member.balancing_group.district.daytime_start_time_index_id..bg_member.balancing_group.district.daytime_end_time_index_id).include?(time_index_id)
  end
end
