# == Schema Information
#
# Table name: jbu_contracts
#
#  id                                      :bigint(8)        not null, primary key
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
  belongs_to :company
  belongs_to :district

  #
  # 基本料
  #
  # @return 契約電力 x 基本料率
  def bacic_amount
    contract_power * basic_charge
  end

  #
  # パラメータで指定された日付及び時間枠IDにおける従量料金単価を取得する
  #
  # @param date [Date] 日付
  # @param time_index [Integer] 時間枠ID
  # @return [Decimal] 指定日時の従量料金単価
  def meter_rate_charge(date, time_index)
    if Holiday.get_list(district_id).include?(date)
      meter_rate_charge_night
    elsif in_summer_season(date)
      case
      when in_peaktime(time_index)
        meter_rate_charge_peak_time
      when in_daytime(time_index)
        meter_rate_charge_summer_season_daytime
      else
        meter_rate_charge_night
      end
    else
      case
      when in_daytime(time_index)
        meter_rate_charge_other_season_daytime
      else
        meter_rate_charge_night
      end
    end
  end

  private
  #
  # 指定日が休日か否か
  # @param date [Date] チェック対象の日付
  # @return [Boolean] 休日の場合真を返す
  def is_holiday(date)
    Holiday.get_list(district_id).include?(date)
  end

  #
  # 指定日が夏季に含まれるか
  # @param date [Date] チェック対象の日付
  # @return [Boolean] 夏季に含まれる場合真を返す
  def in_summer_season(date)
    (district.summer_season_start_month..district.summer_season_end_month).include?(date.month)
  end

  #
  # 指定の時間枠IDがピークタイムに含まれるか
  # @param time_index_id [Integer] チェック対象の時間枠ID
  # @return [Boolean] ピークタイムに含まれる場合真を返す
  def in_peaktime(time_index_id)
    (district.peaktime_start_time_index_id..district.peaktime_end_time_index_id).include?(time_index_id)
  end

  #
  # 指定の時間枠IDが昼間時間に含まれるか
  # @param time_index_id [Integer] チェック対象の時間枠ID
  # @return [Boolean] 昼間時間に含まれる場合真を返す
  def in_daytime(time_index)
    (district.daytime_start_time_index_id..district.daytime_end_time_index_id).include?(time_index_id)
  end
end
