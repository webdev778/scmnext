class CreateOcctoPlanDetailValues < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_plan_detail_values, comment: "広域需要調達計画(翌日)詳細値データ" do |t|
      t.string "type", limit: 30, comment: "データ種別"
      t.references "resource", comment: "リソースID"
      t.references "plan_by_company", comment: "広域需要調達計画(翌日)PPS別データID"
      t.decimal "value", precision: 14, comment: "数量(kWh)"
      t.stamp_fileds
      t.index [:type, :resource_id, :plan_by_company_id], name: :unique_index_on_business, unique: true
    end
  end
end
