class FixContractItemCalculationOrder < ActiveRecord::Migration[5.2]
  def change
    rename_column :contract_items, "calcuration_order", "calculation_order"
  end
end
