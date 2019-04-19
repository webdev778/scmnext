class AddSupplyValueToResources < ActiveRecord::Migration[5.2]
  def change
    add_column :resources, :supply_value, :text, after: 'name', comment: "供給量"
  end
end
