class Legacy::TblActualElectricalLowPower < Legacy
  self.table_name = "tbl_actual_electrical_low_power"
  self.primary_keys = [:customer_id, :time]

  scope :filter_by_date,  ->(date) {
    where(["time >= ?", date.beginning_of_day]).where(["time <= ?", date.end_of_day])
  }
end
