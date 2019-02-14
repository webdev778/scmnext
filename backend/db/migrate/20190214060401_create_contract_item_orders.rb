class CreateContractItemOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_item_orders, comment: "契約アイテム順序情報" do |t|
      t.references "contract_item_group", comment: "契約アイテムグループID"
      t.references "contract_item", comment: "契約アイテムID"
      t.integer "sort_order", comment: "並び順"
      t.stamp_fileds
    end
  end
end
