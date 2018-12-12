class CreateFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities, comment: "施設" do |t|
      t.string "name", comment: "名前"
      t.string "code", comment: "コード"
      t.references "consumer", comment: "需要家ID"
      t.string "supply_point_number", comment: "供給地点特定番号"
      t.references "district", comment: "供給エリアID"
      t.references "voltage_type", comment: "電圧種別ID"
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
      t.stamp_fileds
    end
  end
end
