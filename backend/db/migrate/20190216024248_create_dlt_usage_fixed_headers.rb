class CreateDltUsageFixedHeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :dlt_usage_fixed_headers, comment: '確定使用量ヘッダ' do |t|
      t.references "file", comment: "ファイルID"
      t.integer "year", limit: 4, null: false, index: true, comment: "年"
      t.integer "month", limit: 2, null: false, index: true, comment: "月"
      t.string "supply_point_number", limit: 22, null: false, index: true, comment: "供給地点特定番号"
      t.string "consumer_code", limit: 21, comment: "需要家識別番号"
      t.string "consumer_name", limit: 80, comment: "需要家名称"
      t.string "supply_point_name", limit: 70, comment: "供給場所"
      t.string "voltage_class_name", limit: 4, comment: "電圧区分名"
      t.integer "journal_code", limit: 1, comment: "仕訳コード: 1:全量,2:部分"
      t.boolean "can_provide", comment: "提供可否"
      t.decimal "usage_all", precision: 10, scale: 4, comment: "月間電力量全量"
      t.decimal "usage", precision: 10, scale: 4, comment: "月間電力量仕訳後"
      t.decimal "power_factor", precision: 10, scale: 4, comment: "力率"
      t.decimal "max_power", precision: 10, scale: 4, comment: "最大需要電力"
      t.date "next_meter_reading_date", comment: "次回定例検針予定日"
      t.stamp_fileds
    end
  end
end
