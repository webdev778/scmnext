class CreateConsumers < ActiveRecord::Migration[5.2]
  def change
    create_table :consumers, comment: "需要家" do |t|
      t.string "name", comment: "名前"
      t.string "code", comment: "コード"
      t.references "company", comment: "PPS ID"
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
      t.stamp_fileds
    end
  end
end
