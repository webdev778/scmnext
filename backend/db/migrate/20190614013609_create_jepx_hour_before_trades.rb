class CreateJepxHourBeforeTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :jepx_hour_before_trades, comment: "時間前市場取引" do |t|
      t.references :resource, comment: "リソースID"
      t.date :date, comment: "日付"
      t.references :time_index, comment: "時間枠ID"
      t.integer :trade_type, limit: 1, null: false, defualt: :null, comment: "取引種別:1:売注文,2:買注文"
      t.integer :unit_price, precision: 10, scale: 4, null: false, default: 0, comment: "単価"
      t.integer :qty, null: false, default: 0, comment: "数量"
      t.stamp_fileds
    end
  end
end
