class AddBgMemgerToDltSettingsAndFacilityGroup < ActiveRecord::Migration[5.2]
  def change
    add_reference :dlt_settings, "bg_member", after: "district_id" ,comment: "BGメンバーID"
    add_reference :facility_groups, "bg_member", after: "district_id" ,comment: "BGメンバーID"
    add_reference :jbu_contracts, "bg_member", after: "district_id" ,comment: "BGメンバーID"
    add_reference :dlt_invalid_supply_points, "bg_member", after: "district_id" ,comment: "BGメンバーID"
  end
end
