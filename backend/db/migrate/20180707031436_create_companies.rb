class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies, comment: "会社(PPS)" do |t|
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
      t.stamp_fileds
    end
  end
end
