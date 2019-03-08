class CreateFuelCostAdjustments < ActiveRecord::Migration[5.2]
  def change
    create_table :fuel_cost_adjustments, comment: "燃料調整費" do |t|
      t.references "district", comment: "エリアID"
      t.integer "year", limit: 4, null: false, index: true, comment: "年"
      t.integer "month", limit: 2, null: false, index: true, comment: "月"
      t.integer "voltage_class", limit: 1, null: false, comment: "電圧区分"
      t.decimal "unit_price", precision: 10, scale: 4, comment: "単価"
      t.stamp_fileds
      t.index [:district_id, :year, :month], name: :unique_index_for_import, unique: true
    end
  end
end
