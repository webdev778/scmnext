class CreateJepxSpotTradeAreaData < ActiveRecord::Migration[5.2]
  def change
    create_table :jepx_spot_trade_area_data, comment: "JEPXスポット市場取引結果エリア別情報" do |t|
      t.references "spot_trade", comment: "JEPXスポット市場取引結果ID"
      t.references "district", comment: "エリアID"
      t.decimal "area_price", precision: 5, scale: 2, comment: "エリアプライス(円/kWh)"
      t.decimal "avoidable_price", precision: 5, scale: 2, comment: "回避可能原価(円/kWh)"
      t.stamp_fileds
      t.index [:spot_trade_id, :district_id], name: :unique_index_on_business, unique: true
    end
  end
end
