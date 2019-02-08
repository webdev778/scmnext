class CreatePowerUsagePreliminaries < ActiveRecord::Migration[5.2]
  def change
    create_table :power_usage_preliminaries, comment: "電力使用量(速報値)" do |t|
      t.references "facility_group", null: false, comment: "施設グループID"
      t.date "date", null: false, index: true, comment: "日付"
      t.references "time_index", null: false, comment: "時間枠ID"
      t.decimal "value", precision: 10, scale: 4, comment: "使用量(kwh)"
      t.stamp_fileds
      t.index [:facility_group_id, :date, :time_index_id], name: :unique_index_for_import, unique: true
    end
  end
end
