class CreateDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :districts, comment: "供給エリア" do |t|
      t.string "name", comment: "名前"
      t.string "code", comment: "コード"
      t.string "wheeler_code", comment: "託送コード"
      t.float "loss_rate_special_high_voltage", comment: "損失率(特別高圧)"
      t.float "loss_rate_high_voltage", comment: "損失率(高圧)"
      t.float "loss_rate_low_voltage", comment: "損失率(低圧)"
      t.string "dlt_host", comment: "託送ダウンロード用ホスト名"
      t.string "dlt_path", comment: "託送ダウンロードパス名"
      t.boolean "is_partial_included", null: false, defualt: true, comment: "電力量データ部分供給内包有無"
      t.references "daytime_start_time_index", comment: "昼間時間開始時間枠ID"
      t.references "daytime_end_time_index", comment: "昼間時間終了時間枠ID"
      t.references "peaktime_start_time_index", comment: "ピークタイム開始時間枠ID"
      t.references "peaktime_end_time_index", comment: "ピークタイム終了時間枠ID"
      t.integer "summer_season_start_month", comment: "夏季開始月"
      t.integer "summer_season_end_month", comment: "夏季終了月"
      t.stamp_fileds
    end
  end
end
