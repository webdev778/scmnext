class CreateContractMeterRates < ActiveRecord::Migration[5.2]
  def change
    create_table :contract_meter_rates, comment: "契約・契約アイテム別従量料金" do |t|
      t.references "contract", comment: "契約ID"
      t.references "contract_item", comment: "契約アイテムID"
      t.date "start_date", index: true, comment: "開始日"
      t.date "end_date", index: true, comment: "終了日"
      t.decimal "rate", precision: 10, scale: 4, comment: "レート"
      t.stamp_fileds
    end
  end
end
