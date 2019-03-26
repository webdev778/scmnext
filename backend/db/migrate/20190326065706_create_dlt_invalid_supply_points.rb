class CreateDltInvalidSupplyPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :dlt_invalid_supply_points, comment: "不整合供給地点" do |t|
      t.references "company", comment: "PPS ID"
      t.references "district", comment: "エリアID"
      t.string "number", comment: "供給地点特定番号"
      t.string "name", comment: "顧客名"
      t.string "comment", comment: "内容"
      t.stamp_fileds

      t.index [:company_id, :district_id, :number], name: :unique_index_for_business, unique: true
    end
  end
end
