class CreateOcctoFitPlanByResoures < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_fit_plan_by_resoures, comment: "広域発電販売(翌日)リソース別(発電BG別)データ"  do |t|
      t.references "fit_plan", comment: "広域発電販売(翌日)ID"
      t.references "resource", comment: "リソースID"
      t.stamp_fileds
      t.index [:fit_plan_id, :resource_id], name: :unique_index_on_business, unique: true
    end
  end
end
