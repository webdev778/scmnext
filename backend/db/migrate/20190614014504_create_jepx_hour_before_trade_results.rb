class CreateJepxHourBeforeTradeResults < ActiveRecord::Migration[5.2]
  def change
    create_table :jepx_hour_before_trade_results, comment: "時間前市場取引結果" do |t|
      t.references :hour_before_trade, comment: "時間前市場取引ID"
      t.boolean :is_applied_to_plan, default: false, null: false, comment: "計画反映済"
      t.integer :unit_price, precision: 10, scale: 4, null: false, default: 0, comment: "単価"
      t.integer :qty, null: false, default: 0, comment: "数量"
      t.timestamps
    end
  end
end
