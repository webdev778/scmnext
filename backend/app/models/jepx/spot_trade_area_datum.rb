# == Schema Information
#
# Table name: jepx_spot_trade_area_data
#
#  id              :bigint(8)        not null, primary key
#  spot_trade_id   :bigint(8)
#  district_id     :bigint(8)
#  area_price      :decimal(5, 2)
#  avoidable_price :decimal(5, 2)
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Jepx::SpotTradeAreaDatum < ApplicationRecord
  belongs_to :district
  belongs_to :spot_trade

  #
  # 燃料調整費と消費税込のエリアプライスを返す
  # @return [Decimal] 燃料調整費と消費税込のエリアプライス
  def area_price_with_fuel_cost_adjustment_and_tax
    (area_price + (0.03)) * 1.08
  end

  # インバランス単価を取得する
  # (インバランス計算については下記参照のこと)
  # http://www.meti.go.jp/press/2017/09/20170926004/20170926004.html
  # @param data_type [Symbol or String] 速報値ベースの場合はpreliminary,確定値ベースの場合はfixedを指定する
  # @return [Decimal] インバランス単価
  def imbalance_unit_price(data_type)
    @imbalance_unit_price ||= {}
    unless @imbalance_unit_price[data_type]
      raise "date_typeパラメータにはpreliminaryかfixedを指定してください" unless [:preliminary, :fixed].include?(data_type.to_sym)
      imbalance_beta = district.jepx_imbalance_betas.find_by(year: spot_trade.date.year, month: spot_trade.date.month)
      raise "インバランスβ情報が見つかりません。" if imbalance_beta.nil?
      @imbalance_unit_price[data_type] = spot_trade.send("alpha_#{data_type}_time_spot_avg_per_price") * imbalance_beta.value
    end
    @imbalance_unit_price[data_type]
  end
end
