class CreatePlBaseData < ActiveRecord::Migration[5.2]
  def change
    create_table :pl_base_data, comment: "損益計算基本情報" do |t|
      t.references "facility_group", commet: "施設グループID"
      t.string "type", null: false, index: true, comment: "種別"
      t.date "date", null: false, index: true, comment: "日付"
      t.references "time_index", null: false, comment: "時間枠ID"
      t.decimal "amount_actual", precision: 10, scale: 4, comment: "使用量(kwh)"
      t.decimal "amount_planned", precision: 10, scale: 4, comment: "計画値"
      t.decimal "amount_loss", precision: 10, scale: 4, comment: "損失量"
      t.decimal "amount_imbalance", precision: 10, scale: 4, comment: "インバランス"
      t.decimal "power_factor_rate", precision: 10, scale: 4, comment: "力率"
      t.decimal "sales_basic_charge", precision: 10, scale: 4, comment: "売上(基本料)"
      t.decimal "sales_mater_rate_charge", precision: 10, scale: 4, comment: "売上(従量料金)"
      t.decimal "sales_fuel_cost_adjustment", precision: 10, scale: 4, comment: "売上(燃料調整費)"
      t.decimal "sales_cost_adjustment", precision: 10, scale: 4, comment: "売上(調整費)"
      t.decimal "sales_special_discount", precision: 10, scale: 4, comment: "売上(還元割)"
      t.decimal "usage_jbu", precision: 10, scale: 4, comment: "使用量(JBU)"
      t.decimal "usage_jepx_spot", precision: 10, scale: 4, comment: "使用量(JPEXスポット)"
      t.decimal "usage_jepx_1hour", precision: 10, scale: 4, comment: "使用量(JPEX一時間前)"
      t.decimal "usage_fit", precision: 10, scale: 4, comment: "使用量(FIT)"
      t.decimal "usage_matching", precision: 10, scale: 4, comment: "使用量(相対)"
      t.decimal "supply_jbu_basic_charge", precision: 10, scale: 4, comment: "仕入(JBU基本料)"
      t.decimal "supply_jbu_meter_rate_charge", precision: 10, scale: 4, comment: "仕入(JBU従量料金)"
      t.decimal "supply_jbu_fuel_cost_adjustment", precision: 10, scale: 4, comment: "仕入(JBU燃料調整費)"
      t.decimal "supply_jepx_spot", precision: 10, scale: 4, comment: "仕入(JEPXスポット)"
      t.decimal "supply_jepx_1hour", precision: 10, scale: 4, comment: "仕入(JEPX一時間前)"
      t.decimal "supply_fit", precision: 10, scale: 4, comment: "仕入(FIT)"
      t.decimal "supply_matching", precision: 10, scale: 4, comment: "仕入(相対)"
      t.decimal "supply_imbalance", precision: 10, scale: 4, comment: "仕入(インバランス)"
      t.decimal "supply_wheeler_fundamental_charge", precision: 10, scale: 4, comment: "仕入(託送基本料)"
      t.decimal "supply_wheeler_mater_rate_charge", precision: 10, scale: 4, comment: "仕入(託送従量料金)"
      t.stamp_fileds

      t.index [:facility_group_id, :date, :time_index_id], name: :unique_index_for_import, unique: true
    end
  end
end
