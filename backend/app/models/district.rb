# == Schema Information
#
# Table name: districts
#
#  id                              :bigint(8)        not null, primary key
#  name                            :string(255)
#  code                            :string(255)
#  wheeler_code                    :string(255)
#  loss_rate_special_high_voltage  :float(24)
#  loss_rate_high_voltage          :float(24)
#  loss_rate_low_voltage           :float(24)
#  dlt_host                        :string(255)
#  dlt_path                        :string(255)
#  is_partial_included             :boolean          not null
#  daytime_start_time_index_id_id  :bigint(8)
#  daytime_end_time_index_id_id    :bigint(8)
#  peaktime_start_time_index_id_id :bigint(8)
#  peaktime_end_time_index_id_id   :bigint(8)
#  summer_season_start_month       :integer
#  summer_season_end_month         :integer
#  created_by                      :integer
#  updated_by                      :integer
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class District < ApplicationRecord
  has_many :jepx_imbalance_betas, class_name: Jepx::ImbalanceBeta.to_s
  has_many :spot_trade_area_data, class_name: Jepx::SpotTradeAreaDatum.to_s
  has_many :holidays
  has_many :fuel_cost_adjustments
  has_many :wheeler_charges
  has_many :district_loss_rates
  has_many :facilities
  belongs_to :daytime_start_time_index, class_name: TimeIndex.to_s, required: false
  belongs_to :daytime_end_time_index, class_name: TimeIndex.to_s, required: false
  belongs_to :peaktime_start_time_index, class_name: TimeIndex.to_s, required: false
  belongs_to :peaktime_end_time_index, class_name: TimeIndex.to_s, required: false

  #
  # 指定日における電圧クラスごとの託送料金テーブルを取得する
  # @param date [Date] 取得する日付
  # @return [Hash] voltage_classをkey,WheelerChargeのインスタンスを値とするハッシュ
  def wheeler_charges_at(date)
    wheeler_charges
      .order(start_date: :asc)
      .where("start_date <= :date", date: date)
      .reduce({}) do |result, wheeler_charge|
        result[wheeler_charge.voltage_class] = wheeler_charge
        result
      end
      .with_indifferent_access
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
