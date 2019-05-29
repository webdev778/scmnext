class CreateOcctoFitPlanDetailValues < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_fit_plan_detail_values, comment: "広域発電販売計画(翌日)詳細値データ" do |t|
      t.references :occto_fit_plan, comment: "広域発電販売計画(翌日)ID"
      t.references :power_generator, comment: "発電者ID"
      t.references :time_index, comment: "時間枠ID"
      t.decimal "value", precision: 14, comment: "数量(kWh)"
      t.stamp_fileds
    end
  end
end
