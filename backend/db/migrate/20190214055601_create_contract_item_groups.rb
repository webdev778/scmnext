class CreateContractItemGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_item_groups, comment: "契約アイテムグループ" do |t|
      t.string "name", null: false, comment: "名前"
      t.references "voltage_type", comment: "電圧種別ID"
      t.stamp_fileds
    end
  end
end
