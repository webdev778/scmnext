class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts, comment: "契約" do |t|
      t.string "name", null: false, comment: "名称"
      t.string "name_for_invoice", null: false, comment: "請求用名称"
      t.references "voltage_type", comment: "電圧種別ID"
      t.references "contract_item_group", comment: "契約アイテムグループID"
      t.date "start_date", comment: "開始日"
      t.date "end_date", comment: "終了日"
      t.stamp_fileds
    end
  end
end
