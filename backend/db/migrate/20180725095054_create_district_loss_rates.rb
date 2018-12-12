class CreateDistrictLossRates < ActiveRecord::Migration[5.2]
  def change
    create_table :district_loss_rates, comment: "エリア別損失率" do |t|
      t.references "district", comment: "エリアID"
      t.references "voltage_type", index: true, comment: "電圧種別ID"
      t.float "rate", comment: "損失率"
      t.date "application_start_date", comment: "適用開始日"
      t.date "application_end_date", comment: "適用終了日"
      t.stamp_fileds
    end
  end
end
