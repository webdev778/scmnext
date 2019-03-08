class CreateWheelerCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :wheeler_charges, comment: "託送料金" do |t|
      t.references "district", comment: "エリアID"
      t.integer "voltage_class", limit: 1, null: false, comment: "電圧区分"
      t.date "start_date", null: false, index: true, comment: "適用開始日"
      t.decimal "basic_charge", precision: 10, scale: 4, comment: "基本料金(kW)"
      t.decimal "meter_rate_charge", precision: 10, scale: 4, comment: "電力量料金(kWh)"
      t.decimal "mater_rate_charge_daytime", precision: 10, scale: 4, comment: "電力量料金(昼間時間)(kWh)"
      t.decimal "mater_rate_charge_night", precision: 10, scale: 4, comment: "電力量料金(夜間時間)(kWh)"
      t.decimal "peak_shift_discount", precision: 10, scale: 4, comment: "ピークシフト割引(kW)"
      t.decimal "a_charge", precision: 10, scale: 4, comment: "予備送電サービスA料金(kW)"
      t.decimal "b_charge", precision: 10, scale: 4, comment: "予備送電サービスB料金(kW)"
      t.stamp_fileds


    end
  end
end
