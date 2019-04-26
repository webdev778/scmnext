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
    logger.warn("TODO 燃調費取得")
    (area_price + (0.03)) * 1.08
  end

  # インバランス単価を取得する
  # (インバランス計算については下記参照のこと)
  # http://www.meti.go.jp/press/2017/09/20170926004/20170926004.html
  #
  # 速報値の場合は可能な限り値を返すこと、確定値の場合は正確な数字を使用することを基本方針とする
  #
  # @param data_type [Symbol or String] 速報値ベースの場合はpreliminary,確定値ベースの場合はfixedを指定する
  # @return [Decimal] インバランス単価
  def imbalance_unit_price(data_type)
    @imbalance_unit_price ||= {}
    unless @imbalance_unit_price[data_type]
      raise "date_typeパラメータにはpreliminaryかfixedを指定してください" unless [:fixed, :preliminary].include?(data_type)

      # β値を取得する
      case data_type
      when :fixed
        beta_price_rec = district.jepx_imbalance_betas.find_by(year: spot_trade.date.year, month: spot_trade.date.month)
      when :preliminary
        beta_price_rec = district.jepx_imbalance_betas.order(year: :desc, month: :desc).first
      end
      unless beta_price_rec
        raise "β値が取得できません"
      end
      beta_price = beta_price_rec.value

      # α値を取得する
      case data_type
      when :fixed
        alpha_price = spot_trade.send("alpha_#{data_type}_times_spot_avg_per_price")
      when :preliminary
        alpha_price = spot_trade.send("alpha_#{data_type}_times_spot_avg_per_price")
        unless alpha_price
          logger.warn "[#{district.name} #{spot_trade.date}(#{spot_trade.time_index_id})]α値が見つからないため、システムプライスを使用"
          alpha_price = spot_trade.system_price
        end
      end
      unless alpha_price
        raise "α値が取得できません"
      end

      @imbalance_unit_price[data_type] = alpha_price * beta_price
    end
    @imbalance_unit_price[data_type]
  end
end
