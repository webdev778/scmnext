class CreateCompanyAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :company_accounts, comment: "会社別アカウント" do |t|
      t.references :company, comment: "会社ID"
      t.string :type, null: false, comment: "種別"
      t.string :login_code, limit: 64, null: false, comment: "ログインコード"
      t.string :password, limit: 64, null: false, comment: "パスワード"
      t.string :passphrase, limit: 64, comment: "パスフレーズ"
      t.string :comment, comment: "備考"
      t.stamp_fileds
      t.index ["id", "type"]
      t.index ["type"]
    end
  end
end
