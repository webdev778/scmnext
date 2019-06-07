class ChangeOcctoFitPlanRelations < ActiveRecord::Migration[5.2]
  def change
    remove_reference :occto_fit_plans, "power_generator_group", after: :id, comment: "発電BG ID"
    add_reference :occto_fit_plans, "bg_member", after: :id, comment: "BGメンバーID"
    remove_reference :occto_fit_plan_detail_values, "occto_fit_plan", after: :id, comment: "広域発電販売計画(翌日)ID"
    add_reference :occto_fit_plan_detail_values, "fit_plan_by_resource", after: :id, comment: "広域発電販売(翌日)リソース別(発電BG別)データID"
    add_index :occto_fit_plans, [:bg_member_id, :date], name: :unique_index_on_business, unique: true
    add_index :occto_fit_plan_detail_values, [:fit_plan_by_resource_id, :power_generator_id, :time_index_id], name: :unique_index_on_business, unique: true
  end
end
