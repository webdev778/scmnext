class CreateFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities, comment: "施設" do |t|
      t.string "name", comment: "名前"
      t.string "code", comment: "コード"
      t.references "consumer", comment: "需要家ID"
      t.references "district", comment: "供給エリアID"
      t.references "voltage_type", comment: "電圧種別ID"
      t.string "contract_capacity", comment: "契約容量"
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
