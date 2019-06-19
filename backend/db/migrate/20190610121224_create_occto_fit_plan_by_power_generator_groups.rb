class CreateOcctoFitPlanByPowerGeneratorGroups < ActiveRecord::Migration[5.2]
  def change
    drop_table :occto_fit_plan_by_resoures, comment: "広域発電販売(翌日)リソース別(発電BG別)データ"  do |t|
      t.references "fit_plan", comment: "広域発電販売(翌日)ID"
      t.references "resource", comment: "リソースID"
      t.stamp_fileds
      t.index [:fit_plan_id, :resource_id], unique: true, name: :unique_index_on_business
    end

    create_table :occto_fit_plan_by_power_generator_groups, comment: "広域発電販売(翌日)発電BG別データ"   do |t|
      t.references "fit_plan", comment: "広域発電販売(翌日)ID"
      t.references "power_generator_group", comment: "発電BG ID", index: {name: "idx_power_generator_group"}
      t.stamp_fileds
      t.index [:fit_plan_id, :power_generator_group_id], name: :unique_index_on_business, unique: true
    end

    remove_index :occto_fit_plan_detail_values,  column: [:fit_plan_by_resource_id, :power_generator_id, :time_index_id], name: :unique_index_on_business, unique: true
    remove_reference :occto_fit_plan_detail_values, "fit_plan_by_resource", after: :id, comment: "広域発電販売(翌日)リソース別(発電BG別)データID", index: {name: "index_occto_fit_plan_detail_values_on_fit_plan_by_resource_id"}
    add_reference :occto_fit_plan_detail_values, "fit_plan_by_power_generator_group", after: :id, comment: "広域発電販売(翌日)発電BG別データID", index: {name: "idx_fit_plan_by_power_generator_group"}
    add_index :occto_fit_plan_detail_values, [:fit_plan_by_power_generator_group_id, :power_generator_id, :time_index_id], name: :unique_index_on_business, unique: true
  end
end
