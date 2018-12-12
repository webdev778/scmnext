class CreatePowerUsagePreliminaries < ActiveRecord::Migration[5.2]
  def change
    create_table :power_usage_preliminaries, comment: "電力使用量" do |t|
      t.references "facility", comment: "施設ID"
      t.date "date", index: true, comment: "日付"
      t.references "time_index", comment: "時間枠ID"
      t.decimal "value", comment: "使用量(kwh)"
      t.stamp_fileds
    end
  end
end
