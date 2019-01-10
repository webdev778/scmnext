class CreateOcctoPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_plans, comment: "広域需要調達計画(翌日)" do |t|
      t.references "balancing_group", comment: "BG ID"
      t.date "date", null: false, comment: "年月日"
      t.stamp_fileds
      t.index [:balancing_group_id, :date], name: :unique_index_on_business, unique: true
    end
  end
end
