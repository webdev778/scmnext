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

ActiveRecord::Schema.define(version: 2018_12_21_053630) do

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
    t.bigint "company_id_id"
    t.string "type", null: false, comment: "種別"
    t.string "login_code", limit: 64, null: false, comment: "ログインコード"
    t.string "password", limit: 64, null: false, comment: "パスワード"
    t.string "comment", comment: "備考"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id_id"], name: "index_company_accounts_on_company_id_id"
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
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "power_usage_preliminaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "電力使用量", force: :cascade do |t|
    t.bigint "facility_id", comment: "施設ID"
    t.date "date", comment: "日付"
    t.bigint "time_index_id", comment: "時間枠ID"
    t.decimal "value", precision: 10, comment: "使用量(kwh)"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_power_usage_preliminaries_on_date"
    t.index ["facility_id"], name: "index_power_usage_preliminaries_on_facility_id"
    t.index ["time_index_id"], name: "index_power_usage_preliminaries_on_time_index_id"
  end

  create_table "time_indices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.time "time", comment: "時間"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "ユーザー", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.string "password", comment: "パスワード"
    t.string "accesable_type"
    t.bigint "accesable_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accesable_type", "accesable_id"], name: "index_users_on_accesable_type_and_accesable_id"
  end

  create_table "voltage_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", comment: "名前"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
