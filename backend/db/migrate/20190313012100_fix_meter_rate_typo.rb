class FixMeterRateTypo < ActiveRecord::Migration[5.2]
  def change
    rename_column :pl_base_data, "sales_mater_rate_charge", "sales_meter_rate_charge"
    rename_column :pl_base_data, "supply_wheeler_mater_rate_charge", "supply_wheeler_meter_rate_charge"
    rename_column :wheeler_charges, "mater_rate_charge_daytime", "meter_rate_charge_daytime"
    rename_column :wheeler_charges, "mater_rate_charge_night", "meter_rate_charge_night"
  end
end
