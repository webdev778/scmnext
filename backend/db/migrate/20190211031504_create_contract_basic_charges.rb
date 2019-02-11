class CreateContractBasicCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_basic_charges, comment: "契約基本料金" do |t|
      t.references "contract", comment: "契約ID"
      t.date "start_date", null: false, index: true, comment: "適用開始日"
      t.decimal "amount", precision: 10, scale: 4, comment: "金額"
      t.stamp_fileds
    end
  end
end
