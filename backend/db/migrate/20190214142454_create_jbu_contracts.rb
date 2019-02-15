class CreateJbuContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :jbu_contracts, comment: "常時バックアップ電源契約" do |t|
      t.references "district", comment: "エリアID"
      t.references "company", comment: "PPS ID"
      t.date "start_date", comment: "開始日"
      t.date "end_date", comment: "終了日"
      t.integer "contract_power", comment: "契約容量"
      t.decimal "basic_charge", precision: 10, scale: 4, comment: "基本料金(kW)"
      t.decimal "meter_rate_charge_summer_season_daytime", precision: 10, scale: 4, comment: "従量料金(夏季昼間)"
      t.decimal "meter_rate_charge_other_season_daytime", precision: 10, scale: 4, comment: "従量料金(他季昼間)"
      t.decimal "meter_rate_charge_night", precision: 10, scale: 4, comment: "従量料金(夜間)"
      t.decimal "meter_rate_charge_peak_time", precision: 10, scale: 4, comment: "従量料金(ピークタイム)"
      t.stamp_fileds
    end
  end
end
