class CreatePowerSupplyPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :power_supply_plans, comment: "調達計画" do |t|
      t.references "company", comment: "PPS ID"
      t.references "district", comment: "エリアID"
      t.date "date", index: true, comment: "日付"
      t.integer "time_index_id", index: true, comment: "時間枠ID"
      t.integer "supply_type", comment: "供給元区分"
      t.integer "value", comment: "計画値"
      t.references "interchange_company", comment: "融通先PPS ID"
      t.stamp_fileds
    end
  end
end
