class CreateContractItems < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_items, comment: "契約アイテム" do |t|
      t.string "name", null: false, comment: "名前"
      t.references "voltage_type", comment: "電圧区分ID"
      t.integer "calcuration_order", comment: "計算順序"
      t.boolean "enabled", comment: "有効フラグ:未使用?要確認"
      t.stamp_fileds
    end
  end
end
