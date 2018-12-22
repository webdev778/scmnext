class CreateDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :districts, comment: "供給エリア" do |t|
      t.string "name", comment: "名前"
      t.string "code", comment: "コード"
      t.float "loss_rate_special_high_voltage", comment: "損失率(特別高圧)"
      t.float "loss_rate_high_voltage", comment: "損失率(高圧)"
      t.float "loss_rate_low_voltage", comment: "損失率(低圧)"
      t.string "dlt_host", null: false, comment: "託送ダウンロードサーバーホスト名"
      t.stamp_fileds
    end
  end
end
