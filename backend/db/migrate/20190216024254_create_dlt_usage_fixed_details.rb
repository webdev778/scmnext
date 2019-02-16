class CreateDltUsageFixedDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :dlt_usage_fixed_details, comment: "確定使用量明細" do |t|
      t.references "usage_fixed_header", comment: "確定使用量ヘッダID"
      t.date "date", index: true, null: false, comment: "日付"
      t.references "time_index", index: true, null: false, comment: "時間枠ID"
      t.decimal "usage_all", precision: 10, scale: 4, comment: "使用量全量"
      t.decimal "usage", precision: 10, scale: 4, comment: "使用量仕訳後"
      t.stamp_fileds
    end
  end
end
