# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_09_093532) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "balancing_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "バランシンググループ", force: :cascade do |t|
    t.string "code", limit: 5, null: false, comment: "コード"
    t.string "name", limit: 40, null: false, comment: "名前"
    t.bigint "district_id", comment: "エリアID"
    t.bigint "leader_company_id", comment: "リーダーPPS ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_balancing_groups_on_district_id"
    t.index ["leader_company_id"], name: "index_balancing_groups_on_leader_company_id"
  end

  create_table "balancing_groups_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "バランシンググループPPS関連", force: :cascade do |t|
    t.bigint "balancing_group_id", comment: "バランシンググループID"
    t.bigint "company_id", comment: "PPS ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balancing_group_id"], name: "index_balancing_groups_companies_on_balancing_group_id"
    t.index ["company_id"], name: "index_balancing_groups_companies_on_company_id"
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "会社(PPS)", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.string "code", null: false, comment: "コード"
    t.string "name_kana", comment: "名前(カナ)"
    t.string "postal_code", comment: "郵便番号"
    t.integer "pref_no", comment: "都道府県番号"
    t.string "city", comment: "市区町村"
    t.string "address", comment: "住所"
    t.string "tel", comment: "TEL"
    t.string "fax", comment: "FAX"
    t.string "email", comment: "EMAIL"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "会社別アカウント", force: :cascade do |t|
    t.bigint "company_id", comment: "会社ID"
    t.string "type", null: false, comment: "種別"
    t.string "login_code", limit: 64, null: false, comment: "ログインコード"
    t.string "password", limit: 64, null: false, comment: "パスワード"
    t.string "passphrase", limit: 64, comment: "パスフレーズ"
    t.string "comment", comment: "備考"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_accounts_on_company_id"
    t.index ["id", "type"], name: "index_company_accounts_on_id_and_type"
    t.index ["type"], name: "index_company_accounts_on_type"
  end

  create_table "consumers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "需要家", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "code", comment: "コード"
    t.bigint "company_id", comment: "PPS ID"
    t.string "tel", comment: "TEL"
    t.string "fax", comment: "FAX"
    t.string "email", comment: "EMAIL"
    t.string "url", comment: "URL"
    t.string "postral_code", comment: "郵便番号"
    t.integer "pref_no", comment: "都道府県番号"
    t.string "city", comment: "市区町村"
    t.string "address", comment: "住所"
    t.string "person_in_charge", comment: "担当者"
    t.string "person_in_charge_kana", comment: "担当者カナ"
    t.string "password", comment: "パスワード"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_consumers_on_company_id"
  end

  create_table "district_loss_rates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "エリア別損失率", force: :cascade do |t|
    t.bigint "district_id", comment: "エリアID"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.float "rate", comment: "損失率"
    t.date "application_start_date", comment: "適用開始日"
    t.date "application_end_date", comment: "適用終了日"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_district_loss_rates_on_district_id"
    t.index ["voltage_type_id"], name: "index_district_loss_rates_on_voltage_type_id"
  end

  create_table "districts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "供給エリア", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "code", comment: "コード"
    t.float "loss_rate_special_high_voltage", comment: "損失率(特別高圧)"
    t.float "loss_rate_high_voltage", comment: "損失率(高圧)"
    t.float "loss_rate_low_voltage", comment: "損失率(低圧)"
    t.string "dlt_host", comment: "託送ダウンロード用ホスト名"
    t.string "dlt_path", comment: "託送ダウンロードパス名"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dlt_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ダウンロードファイル", force: :cascade do |t|
    t.bigint "setting_id", comment: "ダウンロード設定ID"
    t.integer "state", default: 0, null: false, comment: "状態:(0:未取込,1:取込完了,2:処理中,3:一部取込(エラーあり))"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_id"], name: "index_dlt_files_on_setting_id"
  end

  create_table "dlt_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ダウンロード設定", force: :cascade do |t|
    t.bigint "company_id", comment: "会社ID"
    t.bigint "district_id", comment: "エリアID"
    t.integer "state", default: 0, null: false, comment: "状態:(0:正常, 1:休止中)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_dlt_settings_on_company_id"
    t.index ["district_id"], name: "index_dlt_settings_on_district_id"
  end

  create_table "facilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "施設", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "code", comment: "コード"
    t.bigint "consumer_id", comment: "需要家ID"
    t.string "supply_point_number", comment: "供給地点特定番号"
    t.bigint "district_id", comment: "供給エリアID"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.date "supply_start_date", comment: "供給開始日"
    t.date "supply_end_date", comment: "供給終了日"
    t.string "tel", comment: "TEL"
    t.string "fax", comment: "FAX"
    t.string "email", comment: "EMAIL"
    t.string "url", comment: "URL"
    t.string "postral_code", comment: "郵便番号"
    t.integer "pref_no", comment: "都道府県番号"
    t.string "city", comment: "市区町村"
    t.string "address", comment: "住所"
    t.string "person_in_charge", comment: "担当者"
    t.string "person_in_charge_kana", comment: "担当者カナ"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_id"], name: "index_facilities_on_consumer_id"
    t.index ["district_id"], name: "index_facilities_on_district_id"
    t.index ["voltage_type_id"], name: "index_facilities_on_voltage_type_id"
  end

  create_table "jepx_imbalance_betas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "JEPXインバランスβ値", force: :cascade do |t|
    t.integer "year", null: false, comment: "年"
    t.integer "month", limit: 2, null: false, comment: "月"
    t.bigint "district_id", comment: "エリアID"
    t.decimal "value", precision: 5, scale: 2, comment: "値"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_jepx_imbalance_betas_on_district_id"
    t.index ["year", "month", "district_id"], name: "unique_index_on_business", unique: true
  end

  create_table "jepx_spot_trade_area_data", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "JEPXスポット市場取引結果エリア別情報", force: :cascade do |t|
    t.bigint "spot_trade_id", comment: "JEPXスポット市場取引結果ID"
    t.bigint "district_id", comment: "エリアID"
    t.decimal "area_price", precision: 5, scale: 2, comment: "エリアプライス(円/kWh)"
    t.decimal "avoidable_price", precision: 5, scale: 2, comment: "回避可能原価(円/kWh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_jepx_spot_trade_area_data_on_district_id"
    t.index ["spot_trade_id", "district_id"], name: "unique_index_on_business", unique: true
    t.index ["spot_trade_id"], name: "index_jepx_spot_trade_area_data_on_spot_trade_id"
  end

  create_table "jepx_spot_trades", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "JEPXスポット市場取引結果", force: :cascade do |t|
    t.date "date", null: false, comment: "年月日"
    t.bigint "time_index_id", null: false, comment: "時間枠ID"
    t.decimal "sell_bit_amount", precision: 14, comment: "売り入札量(kWh)"
    t.decimal "buy_bit_amount", precision: 14, comment: "買い入札量(kWh)"
    t.decimal "execution_amount", precision: 14, comment: "約定総量(kWh)"
    t.decimal "system_price", precision: 5, scale: 2, comment: "システムプライス(円/kWh)"
    t.decimal "avoidable_cost", precision: 5, scale: 2, comment: "回避可能原価全国値(円/kWh)"
    t.decimal "spot_avg_per_price", precision: 5, scale: 2, comment: "スポット・時間前平均価格(円/kWh)"
    t.decimal "alpha_max_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α上限値×スポット・時間前平均価格(円/kWh)"
    t.decimal "alpha_min_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α下限値×スポット・時間前平均価格(円/kWh)"
    t.decimal "alpha_preliminary_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α速報値×スポット・時間前平均価格(円/kWh)"
    t.decimal "alpha_fixed_times_spot_avg_per_price", precision: 5, scale: 2, comment: "α確報値×スポット・時間前平均価格(円/kWh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "time_index_id"], name: "unique_index_on_business", unique: true
    t.index ["time_index_id"], name: "index_jepx_spot_trades_on_time_index_id"
  end

  create_table "occto_plan_by_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "広域需要調達計画(翌日)PPS別データ", force: :cascade do |t|
    t.bigint "plan_id", comment: "広域需要調達計画(翌日)ID"
    t.bigint "company_id", comment: "PPS ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_occto_plan_by_companies_on_company_id"
    t.index ["plan_id", "company_id"], name: "unique_index_on_business", unique: true
    t.index ["plan_id"], name: "index_occto_plan_by_companies_on_plan_id"
  end

  create_table "occto_plan_detail_values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "広域需要調達計画(翌日)詳細値データ", force: :cascade do |t|
    t.string "type", limit: 30, comment: "データ種別"
    t.bigint "resource_id", comment: "リソースID"
    t.bigint "plan_by_company_id", comment: "広域需要調達計画(翌日)PPS別データID"
    t.decimal "value", precision: 14, comment: "数量(kWh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_by_company_id"], name: "index_occto_plan_detail_values_on_plan_by_company_id"
    t.index ["resource_id"], name: "index_occto_plan_detail_values_on_resource_id"
    t.index ["type", "resource_id", "plan_by_company_id"], name: "unique_index_on_business", unique: true
  end

  create_table "occto_plans", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "広域需要調達計画(翌日)", force: :cascade do |t|
    t.bigint "balancing_group_id", comment: "BG ID"
    t.date "date", null: false, comment: "年月日"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balancing_group_id", "date"], name: "unique_index_on_business", unique: true
    t.index ["balancing_group_id"], name: "index_occto_plans_on_balancing_group_id"
  end

  create_table "power_supply_plans", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "調達計画", force: :cascade do |t|
    t.bigint "company_id", comment: "PPS ID"
    t.bigint "district_id", comment: "エリアID"
    t.date "date", comment: "日付"
    t.integer "time_index_id", comment: "時間枠ID"
    t.integer "supply_type", comment: "供給元区分"
    t.integer "value", comment: "計画値"
    t.bigint "interchange_company_id", comment: "融通先PPS ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_power_supply_plans_on_company_id"
    t.index ["date"], name: "index_power_supply_plans_on_date"
    t.index ["district_id"], name: "index_power_supply_plans_on_district_id"
    t.index ["interchange_company_id"], name: "index_power_supply_plans_on_interchange_company_id"
    t.index ["time_index_id"], name: "index_power_supply_plans_on_time_index_id"
  end

  create_table "power_usage_fixeds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電力使用量(確定値)", force: :cascade do |t|
    t.bigint "facility_id", null: false, comment: "施設ID"
    t.date "date", null: false, comment: "日付"
    t.bigint "time_index_id", null: false, comment: "時間枠ID"
    t.decimal "value", precision: 10, scale: 4, comment: "使用量(kwh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_power_usage_fixeds_on_date"
    t.index ["facility_id", "date", "time_index_id"], name: "unique_index_for_import", unique: true
    t.index ["facility_id"], name: "index_power_usage_fixeds_on_facility_id"
    t.index ["time_index_id"], name: "index_power_usage_fixeds_on_time_index_id"
  end

  create_table "power_usage_preliminaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電力使用量", force: :cascade do |t|
    t.bigint "facility_id", null: false, comment: "施設ID"
    t.date "date", null: false, comment: "日付"
    t.bigint "time_index_id", null: false, comment: "時間枠ID"
    t.decimal "value", precision: 10, scale: 4, comment: "使用量(kwh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_power_usage_preliminaries_on_date"
    t.index ["facility_id", "date", "time_index_id"], name: "unique_index_for_import", unique: true
    t.index ["facility_id"], name: "index_power_usage_preliminaries_on_facility_id"
    t.index ["time_index_id"], name: "index_power_usage_preliminaries_on_time_index_id"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "リソース", force: :cascade do |t|
    t.bigint "company_id", comment: "会社ID"
    t.string "code", null: false, comment: "コード"
    t.string "type", null: false, comment: "種別"
    t.string "name", null: false, comment: "名称"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_resources_on_company_id"
  end

  create_table "time_indices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "時間枠", force: :cascade do |t|
    t.time "time", comment: "時間"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザー", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "email", default: "", null: false, comment: "E-Mail"
    t.string "encrypted_password", default: "", null: false, comment: "パスワード(暗号化済)"
    t.string "reset_password_token", comment: "パスワードリセット時トークン"
    t.datetime "reset_password_sent_at", comment: "パスワードリセット要求日時"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false, comment: "サインイン回数"
    t.datetime "current_sign_in_at", comment: "現在サインイン日時"
    t.datetime "last_sign_in_at", comment: "最終サインイン日時"
    t.string "current_sign_in_ip", comment: "現在サインインIPアドレス"
    t.string "last_sign_in_ip", comment: "最終サインインIPアドレス"
    t.text "tokens"
    t.string "accesable_type"
    t.bigint "accesable_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accesable_type", "accesable_id"], name: "index_users_on_accesable_type_and_accesable_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "voltage_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電圧区分", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
