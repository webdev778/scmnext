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

ActiveRecord::Schema.define(version: 2019_04_05_023608) do

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

  create_table "bg_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "BGメンバー", force: :cascade do |t|
    t.bigint "balancing_group_id", comment: "バランシンググループID"
    t.bigint "company_id", comment: "PPS ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balancing_group_id"], name: "index_bg_members_on_balancing_group_id"
    t.index ["company_id"], name: "index_bg_members_on_company_id"
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
    t.string "postal_code"
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

  create_table "contract_basic_charges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "契約基本料金", force: :cascade do |t|
    t.bigint "contract_id", comment: "契約ID"
    t.date "start_date", null: false, comment: "適用開始日"
    t.decimal "amount", precision: 10, scale: 4, comment: "金額"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_basic_charges_on_contract_id"
    t.index ["start_date"], name: "index_contract_basic_charges_on_start_date"
  end

  create_table "contract_item_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "契約アイテムグループ", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voltage_type_id"], name: "index_contract_item_groups_on_voltage_type_id"
  end

  create_table "contract_item_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "契約アイテム順序情報", force: :cascade do |t|
    t.bigint "contract_item_group_id", comment: "契約アイテムグループID"
    t.bigint "contract_item_id", comment: "契約アイテムID"
    t.integer "sort_order", comment: "並び順"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_item_group_id"], name: "index_contract_item_orders_on_contract_item_group_id"
    t.index ["contract_item_id"], name: "index_contract_item_orders_on_contract_item_id"
  end

  create_table "contract_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "契約アイテム", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.integer "calculation_order"
    t.boolean "enabled", comment: "有効フラグ:未使用?要確認"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voltage_type_id"], name: "index_contract_items_on_voltage_type_id"
  end

  create_table "contract_meter_rates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "契約・契約アイテム別従量料金", force: :cascade do |t|
    t.bigint "contract_id", comment: "契約ID"
    t.bigint "contract_item_id", comment: "契約アイテムID"
    t.date "start_date", comment: "開始日"
    t.date "end_date", comment: "終了日"
    t.decimal "rate", precision: 10, scale: 4, comment: "レート"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_contract_meter_rates_on_contract_id"
    t.index ["contract_item_id"], name: "index_contract_meter_rates_on_contract_item_id"
    t.index ["end_date"], name: "index_contract_meter_rates_on_end_date"
    t.index ["start_date"], name: "index_contract_meter_rates_on_start_date"
  end

  create_table "contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "契約", force: :cascade do |t|
    t.string "name", null: false, comment: "名称"
    t.string "name_for_invoice", null: false, comment: "請求用名称"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.bigint "contract_item_group_id", comment: "契約アイテムグループID"
    t.date "start_date", comment: "開始日"
    t.date "end_date", comment: "終了日"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_item_group_id"], name: "index_contracts_on_contract_item_group_id"
    t.index ["voltage_type_id"], name: "index_contracts_on_voltage_type_id"
  end

  create_table "discounts_for_facilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "施設別割引", force: :cascade do |t|
    t.bigint "facility_id", comment: "施設ID"
    t.date "start_date", null: false, comment: "適用開始日"
    t.decimal "rate", precision: 10, scale: 4, null: false, comment: "割引率"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id", "start_date"], name: "unique_index_on_business_logic", unique: true
    t.index ["facility_id"], name: "index_discounts_for_facilities_on_facility_id"
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
    t.string "wheeler_code", comment: "託送コード"
    t.float "loss_rate_special_high_voltage", comment: "損失率(特別高圧)"
    t.float "loss_rate_high_voltage", comment: "損失率(高圧)"
    t.float "loss_rate_low_voltage", comment: "損失率(低圧)"
    t.string "dlt_host", comment: "託送ダウンロード用ホスト名"
    t.string "dlt_path", comment: "託送ダウンロードパス名"
    t.boolean "is_partial_included", null: false, comment: "電力量データ部分供給内包有無"
    t.bigint "daytime_start_time_index_id", comment: "昼間時間開始時間枠ID"
    t.bigint "daytime_end_time_index_id", comment: "昼間時間終了時間枠ID"
    t.bigint "peaktime_start_time_index_id", comment: "ピークタイム開始時間枠ID"
    t.bigint "peaktime_end_time_index_id", comment: "ピークタイム終了時間枠ID"
    t.integer "summer_season_start_month", comment: "夏季開始月"
    t.integer "summer_season_end_month", comment: "夏季終了月"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["daytime_end_time_index_id"], name: "index_districts_on_daytime_end_time_index_id"
    t.index ["daytime_start_time_index_id"], name: "index_districts_on_daytime_start_time_index_id"
    t.index ["peaktime_end_time_index_id"], name: "index_districts_on_peaktime_end_time_index_id"
    t.index ["peaktime_start_time_index_id"], name: "index_districts_on_peaktime_start_time_index_id"
  end

  create_table "dlt_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ダウンロードファイル", force: :cascade do |t|
    t.bigint "setting_id", comment: "ダウンロード設定ID"
    t.integer "voltage_mode", limit: 1, comment: "電圧モード"
    t.integer "data_type", limit: 1, comment: "データ種別"
    t.date "record_date", comment: "記録日:速報値の場合は、取得開始年月日、確定値の場合は検針日"
    t.integer "record_time_index_id", limit: 2, comment: "記録時間枠ID:当日データのみ"
    t.integer "section_number", comment: "分割番号"
    t.integer "revision", limit: 2, comment: "更新番号"
    t.integer "state", default: 0, null: false, comment: "状態:(0:未取込,1:取込完了,2:処理中,3:一部取込(エラーあり))"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_id"], name: "index_dlt_files_on_setting_id"
  end

  create_table "dlt_invalid_supply_points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "不整合供給地点", force: :cascade do |t|
    t.bigint "company_id", comment: "PPS ID"
    t.bigint "district_id", comment: "エリアID"
    t.bigint "bg_member_id", comment: "BGメンバーID"
    t.string "number", comment: "供給地点特定番号"
    t.string "name", comment: "顧客名"
    t.string "comment", comment: "内容"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bg_member_id"], name: "index_dlt_invalid_supply_points_on_bg_member_id"
    t.index ["company_id", "district_id", "number"], name: "unique_index_for_business", unique: true
    t.index ["company_id"], name: "index_dlt_invalid_supply_points_on_company_id"
    t.index ["district_id"], name: "index_dlt_invalid_supply_points_on_district_id"
  end

  create_table "dlt_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ダウンロード設定", force: :cascade do |t|
    t.bigint "company_id", comment: "会社ID"
    t.bigint "district_id", comment: "エリアID"
    t.bigint "bg_member_id", comment: "BGメンバーID"
    t.integer "state", default: 0, null: false, comment: "状態:(0:正常, 1:休止中)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bg_member_id"], name: "index_dlt_settings_on_bg_member_id"
    t.index ["company_id"], name: "index_dlt_settings_on_company_id"
    t.index ["district_id"], name: "index_dlt_settings_on_district_id"
  end

  create_table "dlt_usage_fixed_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "確定使用量明細", force: :cascade do |t|
    t.bigint "usage_fixed_header_id", comment: "確定使用量ヘッダID"
    t.date "date"
    t.bigint "time_index_id", comment: "時間枠ID"
    t.decimal "usage_all", precision: 10, scale: 4, comment: "使用量全量"
    t.decimal "usage", precision: 10, scale: 4, comment: "使用量仕訳後"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "ix_date"
    t.index ["time_index_id"], name: "index_dlt_usage_fixed_details_on_time_index_id"
    t.index ["usage_fixed_header_id"], name: "index_dlt_usage_fixed_details_on_usage_fixed_header_id"
  end

  create_table "dlt_usage_fixed_headers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "確定使用量ヘッダ", force: :cascade do |t|
    t.bigint "file_id", comment: "ファイルID"
    t.integer "year", null: false, comment: "年"
    t.integer "month", limit: 2, null: false, comment: "月"
    t.string "supply_point_number", limit: 22, null: false, comment: "供給地点特定番号"
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
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_id"], name: "index_dlt_usage_fixed_headers_on_file_id"
    t.index ["month"], name: "index_dlt_usage_fixed_headers_on_month"
    t.index ["supply_point_number"], name: "index_dlt_usage_fixed_headers_on_supply_point_number"
    t.index ["year"], name: "index_dlt_usage_fixed_headers_on_year"
  end

  create_table "facilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "施設", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "code", comment: "コード"
    t.bigint "consumer_id", comment: "需要家ID"
    t.bigint "district_id", comment: "供給エリアID"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.string "contract_capacity", comment: "契約容量"
    t.string "tel", comment: "TEL"
    t.string "fax", comment: "FAX"
    t.string "email", comment: "EMAIL"
    t.string "url", comment: "URL"
    t.string "postal_code"
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

  create_table "facility_contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "施設契約", force: :cascade do |t|
    t.bigint "facility_id", comment: "施設ID"
    t.bigint "contract_id", comment: "契約ID"
    t.date "start_date", comment: "開始日"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_facility_contracts_on_contract_id"
    t.index ["facility_id"], name: "index_facility_contracts_on_facility_id"
  end

  create_table "facility_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "施設グループ", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.bigint "company_id", comment: "PPS ID"
    t.bigint "district_id", comment: "エリアID"
    t.bigint "bg_member_id", comment: "BGメンバーID"
    t.bigint "contract_id", comment: "契約ID"
    t.bigint "voltage_type_id", comment: "電圧種別ID"
    t.string "contract_capacity", comment: "契約容量"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bg_member_id"], name: "index_facility_groups_on_bg_member_id"
    t.index ["company_id"], name: "index_facility_groups_on_company_id"
    t.index ["contract_id"], name: "index_facility_groups_on_contract_id"
    t.index ["district_id"], name: "index_facility_groups_on_district_id"
    t.index ["voltage_type_id"], name: "index_facility_groups_on_voltage_type_id"
  end

  create_table "fuel_cost_adjustments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "燃料調整費", force: :cascade do |t|
    t.bigint "district_id", comment: "エリアID"
    t.integer "year", null: false, comment: "年"
    t.integer "month", limit: 2, null: false, comment: "月"
    t.integer "voltage_class", limit: 1, null: false, comment: "電圧区分"
    t.decimal "unit_price", precision: 10, scale: 4, comment: "単価"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id", "year", "month"], name: "unique_index_for_import", unique: true
    t.index ["district_id"], name: "index_fuel_cost_adjustments_on_district_id"
    t.index ["month"], name: "index_fuel_cost_adjustments_on_month"
    t.index ["year"], name: "index_fuel_cost_adjustments_on_year"
  end

  create_table "holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "休日", force: :cascade do |t|
    t.bigint "district_id", comment: "エリアID"
    t.date "date", comment: "日付"
    t.string "name", comment: "名称"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_holidays_on_district_id"
  end

  create_table "jbu_contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "常時バックアップ電源契約", force: :cascade do |t|
    t.bigint "district_id", comment: "エリアID"
    t.bigint "bg_member_id", comment: "BGメンバーID"
    t.bigint "company_id", comment: "PPS ID"
    t.date "start_date", comment: "開始日"
    t.date "end_date", comment: "終了日"
    t.integer "contract_power", comment: "契約容量"
    t.decimal "basic_charge", precision: 10, scale: 4, comment: "基本料金(kW)"
    t.decimal "meter_rate_charge_summer_season_daytime", precision: 10, scale: 4, comment: "従量料金(夏季昼間)"
    t.decimal "meter_rate_charge_other_season_daytime", precision: 10, scale: 4, comment: "従量料金(他季昼間)"
    t.decimal "meter_rate_charge_night", precision: 10, scale: 4, comment: "従量料金(夜間)"
    t.decimal "meter_rate_charge_peak_time", precision: 10, scale: 4, comment: "従量料金(ピークタイム)"
    t.decimal "fuel_cost_adjustment_charge", precision: 10, scale: 4, comment: "燃料費調整単価"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bg_member_id"], name: "index_jbu_contracts_on_bg_member_id"
    t.index ["company_id"], name: "index_jbu_contracts_on_company_id"
    t.index ["district_id"], name: "index_jbu_contracts_on_district_id"
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

  create_table "occto_plan_by_bg_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "広域需要調達計画(翌日)BGメンバー別データ", force: :cascade do |t|
    t.bigint "plan_id", comment: "広域需要調達計画(翌日)ID"
    t.bigint "bg_member_id", comment: "BGメンバーID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bg_member_id"], name: "index_occto_plan_by_bg_members_on_bg_member_id"
    t.index ["plan_id", "bg_member_id"], name: "unique_index_on_business", unique: true
    t.index ["plan_id"], name: "index_occto_plan_by_bg_members_on_plan_id"
  end

  create_table "occto_plan_detail_values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "広域需要調達計画(翌日)詳細値データ", force: :cascade do |t|
    t.string "type", limit: 30, comment: "データ種別"
    t.bigint "plan_by_bg_member_id", comment: "広域需要調達計画(翌日)BGメンバー別データID"
    t.bigint "resource_id", comment: "リソースID"
    t.bigint "time_index_id", comment: "時間枠ID"
    t.decimal "value", precision: 14, comment: "数量(kWh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_by_bg_member_id"], name: "index_occto_plan_detail_values_on_plan_by_bg_member_id"
    t.index ["resource_id"], name: "index_occto_plan_detail_values_on_resource_id"
    t.index ["time_index_id"], name: "index_occto_plan_detail_values_on_time_index_id"
    t.index ["type", "plan_by_bg_member_id", "resource_id", "time_index_id"], name: "unique_index_on_business", unique: true
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

  create_table "pl_base_data", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "損益計算基本情報", force: :cascade do |t|
    t.bigint "facility_group_id"
    t.string "type", null: false, comment: "種別"
    t.date "date", null: false, comment: "日付"
    t.bigint "time_index_id", null: false, comment: "時間枠ID"
    t.decimal "amount_actual", precision: 10, scale: 4, comment: "使用量(kwh)"
    t.decimal "amount_planned", precision: 10, scale: 4, comment: "計画値"
    t.decimal "amount_loss", precision: 10, scale: 4, comment: "損失量"
    t.decimal "amount_imbalance", precision: 10, scale: 4, comment: "インバランス"
    t.decimal "power_factor_rate", precision: 10, scale: 4, comment: "力率"
    t.decimal "sales_basic_charge", precision: 10, scale: 4, comment: "売上(基本料)"
    t.decimal "sales_meter_rate_charge", precision: 10, scale: 4
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
    t.decimal "supply_wheeler_meter_rate_charge", precision: 10, scale: 4
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_pl_base_data_on_date"
    t.index ["facility_group_id", "date", "time_index_id"], name: "unique_index_for_import", unique: true
    t.index ["facility_group_id"], name: "index_pl_base_data_on_facility_group_id"
    t.index ["time_index_id"], name: "index_pl_base_data_on_time_index_id"
    t.index ["type"], name: "index_pl_base_data_on_type"
  end

  create_table "power_usage_fixeds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電力使用量(確定値)", force: :cascade do |t|
    t.bigint "facility_group_id", null: false, comment: "施設グループID"
    t.date "date", null: false, comment: "日付"
    t.bigint "time_index_id", null: false, comment: "時間枠ID"
    t.decimal "value", precision: 10, scale: 4, comment: "使用量(kwh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_power_usage_fixeds_on_date"
    t.index ["facility_group_id", "date", "time_index_id"], name: "unique_index_for_import", unique: true
    t.index ["facility_group_id"], name: "index_power_usage_fixeds_on_facility_group_id"
    t.index ["time_index_id"], name: "index_power_usage_fixeds_on_time_index_id"
  end

  create_table "power_usage_preliminaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電力使用量(速報値)", force: :cascade do |t|
    t.bigint "facility_group_id", null: false, comment: "施設グループID"
    t.date "date", null: false, comment: "日付"
    t.bigint "time_index_id", null: false, comment: "時間枠ID"
    t.decimal "value", precision: 10, scale: 4, comment: "使用量(kwh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_power_usage_preliminaries_on_date"
    t.index ["facility_group_id", "date", "time_index_id"], name: "unique_index_for_import", unique: true
    t.index ["facility_group_id"], name: "index_power_usage_preliminaries_on_facility_group_id"
    t.index ["time_index_id"], name: "index_power_usage_preliminaries_on_time_index_id"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "リソース", force: :cascade do |t|
    t.bigint "balancing_group_id", comment: "バランシンググループID"
    t.string "type", null: false, comment: "種別"
    t.string "code", null: false, comment: "コード"
    t.string "name", null: false, comment: "名称"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balancing_group_id"], name: "index_resources_on_balancing_group_id"
  end

  create_table "supply_points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "供給地点", force: :cascade do |t|
    t.string "number", limit: 30, null: false, comment: "供給地点特定番号"
    t.date "supply_start_date", comment: "供給開始日"
    t.date "supply_end_date", comment: "供給終了日"
    t.integer "supply_method_type", null: false, comment: "供給区分: 1:全量, 2:部分"
    t.integer "base_power", comment: "ベース電源"
    t.bigint "facility_group_id", comment: "施設グループID"
    t.bigint "facility_id", comment: "施設ID"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_group_id"], name: "index_supply_points_on_facility_group_id"
    t.index ["facility_id"], name: "index_supply_points_on_facility_id"
    t.index ["number"], name: "index_supply_points_on_number"
  end

  create_table "time_indices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "時間枠", force: :cascade do |t|
    t.time "time", comment: "時間"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザー", force: :cascade do |t|
    t.string "provider", default: "email", null: false, comment: "プロバイダ"
    t.string "uid", default: "", null: false, comment: "UID"
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
    t.string "password_salt", comment: "パスワードソルト"
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

  create_table "voltage_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電圧種別", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wheeler_charges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "託送料金", force: :cascade do |t|
    t.bigint "district_id", comment: "エリアID"
    t.integer "voltage_class", limit: 1, null: false, comment: "電圧区分"
    t.date "start_date", null: false, comment: "適用開始日"
    t.decimal "basic_charge", precision: 10, scale: 4, comment: "基本料金(kW)"
    t.decimal "meter_rate_charge", precision: 10, scale: 4, comment: "電力量料金(kWh)"
    t.decimal "meter_rate_charge_daytime", precision: 10, scale: 4
    t.decimal "meter_rate_charge_night", precision: 10, scale: 4
    t.decimal "peak_shift_discount", precision: 10, scale: 4, comment: "ピークシフト割引(kW)"
    t.decimal "a_charge", precision: 10, scale: 4, comment: "予備送電サービスA料金(kW)"
    t.decimal "b_charge", precision: 10, scale: 4, comment: "予備送電サービスB料金(kW)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["district_id"], name: "index_wheeler_charges_on_district_id"
    t.index ["start_date"], name: "index_wheeler_charges_on_start_date"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
