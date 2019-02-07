class CreateSupplyPoints < ActiveRecord::Migration[5.2]
  def change
    create_table :supply_points, comment: "供給地点" do |t|
      t.string :number, comment: "供給地点特定番号"
      t.date "supply_start_date", comment: "供給開始日"
      t.date "supply_end_date", comment: "供給終了日"
      t.references :facility_group, comment: "施設グループID"
      t.references :facility, comment: "施設ID"
      t.stamp_fileds
    end
  end
end
