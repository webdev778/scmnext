class CreateJepxSpotTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :jepx_spot_trades, comment: "JEPXスポット市場取引結果" do |t|
      t.date "date", null: false, comment: "年月日"
      t.references "time_index", null: false, comment: "時間枠ID"
      t.decimal "sell_bit_amount", precision: 14, comment: "売り入札量(kWh)"
      t.decimal "buy_bit_amount", precision: 14, comment: "買い入札量(kWh)"
      t.decimal "execution_amount", precision: 14, comment: "約定総量(kWh)"
      t.decimal "system_price", precision: 5, scale: 2, comment: "システムプライス(円/kWh)"
      t.decimal "avoidable_cost", precision: 5, scale: 2, comment: "回避可能原価全国値(円/kWh)"
      t.decimal "spot_avg_per_price", precision: 5, scale: 2, comment: "スポット・時間前平均価格(円/kWh)"
      t.decimal "alpha_max_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α上限値×スポット・時間前平均価格(円/kWh)"
      t.decimal "alpha_min_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α下限値×スポット・時間前平均価格(円/kWh)"
      t.decimal "alpha_preliminary_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α速報値×スポット・時間前平均価格(円/kWh)"
      t.decimal "alpha_fixed_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α確報値×スポット・時間前平均価格(円/kWh)"
      t.stamp_fileds
      t.index [:date, :time_index_id], name: :unique_index_on_business, unique: true
    end
  end
end
