class AddResourcesMinMaxUnit < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :max_value, :decimal, precision: 14, null: false, default: 0, after: :name, comment: "最大量"
    add_column :resources, :min_value, :decimal, precision: 14, null: false, default: 0, after: :max_value, comment: "最小量"
    add_column :resources, :unit, :decimal, precision: 14, null: false, default: 1, after: :min_value, comment: "単位量"
    remove_column :resources, :supply_value, :text, after: :name, comment: "供給量"
  end
end
