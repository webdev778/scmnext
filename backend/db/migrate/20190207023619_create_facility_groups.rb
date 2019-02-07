class CreateFacilityGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_groups, comment: "施設グループ" do |t|
      t.string "name", null: false, comment: "名前"
      t.references "company", comment: "PPS ID"
      t.references "district", comment: "エリアID"
      t.references "contract", comment: "契約ID"
      t.references "voltage_type", comment: "電圧区分ID"
      t.string "contract_capacity", comment: "契約容量"
      t.stamp_fileds

    end
  end
end
