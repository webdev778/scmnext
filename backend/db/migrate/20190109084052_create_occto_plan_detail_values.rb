class CreateOcctoPlanDetailValues < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_plan_detail_values, comment: "広域需要調達計画(翌日)詳細値データ" do |t|
      t.string "type", limit: 30, comment: "データ種別"
      t.references "plan_by_bg_member", comment: "広域需要調達計画(翌日)BGメンバー別データID"
      t.references "resource", comment: "リソースID"
      t.references "time_index", comment: "時間枠ID"
      t.decimal "value", precision: 14, comment: "数量(kWh)"
      t.stamp_fileds
      t.index [:type, :plan_by_bg_member_id, :resource_id, :time_index_id], name: :unique_index_on_business, unique: true
    end
  end
end
