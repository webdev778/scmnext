class CreateFacilityContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_contracts, comment: "施設契約" do |t|
      t.references "facility", comment: "施設ID"
      t.references "contract", comment: "契約ID"
      t.date "start_date", comment: "開始日"
      t.stamp_fileds
    end
  end
end
