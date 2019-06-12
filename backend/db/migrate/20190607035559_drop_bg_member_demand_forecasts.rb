class DropBgMemberDemandForecasts < ActiveRecord::Migration[5.2]
  def change
    drop_table :bg_member_demand_forecasts, comment: "BGメンバー需要予測データ" do |t|
      t.references :bg_member, comment: "BGメンバーID"
      t.references :time_index, comment: "時間枠ID"
      t.date :date, comment: "日付"
      t.decimal :demand_value, precision: 10, scale: 4, comment: "需要量"
      t.stamp_fileds
    end
  end
end
