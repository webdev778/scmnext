class Legacy::TblActualElectricalPower < Legacy
  self.table_name = "tbl_actual_electrical_power"
  self.primary_keys = [:customer_id, :time]

  scope :filter_by_date,  ->(date) {
    where(["time >= ?", date.beginning_of_day]).where(["time <= ?", date.end_of_day])
  }

  scope :filter_by_date_and_time_index_id,  ->(date, time_index_id) {
    time_of_day = TimeIndex::to_time_of_day(time_index_id)
    Time.zone = "GMT"
    where(["time = ?", time_of_day.on(date)])
  }
end
