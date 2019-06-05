class DropPowerGeneratorGroupsAndReferResourceFromPowerGeneratorsDirectory < ActiveRecord::Migration[5.2]
  def change
    drop_table :power_generator_groups, comment: "発電BG" do |t|
      t.references :resource, comment: "リソースID"
      t.string :contract_number, limit: 20, comment: "契約No."
      t.stamp_fileds
    end
    add_reference :power_generators, :resources, after: "id", comment: "リソースID"
    remove_reference :power_generators, :power_generator_group, after: "id", comment: "発電BG ID"
    add_column :resources, :contract_number, :string, limit: 20, after: "name", comment: "契約No."
  end
end
