class CreatePowerGeneratorGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :power_generator_groups, comment: "発電BG" do |t|
      t.references :resource, comment: "リソースID"
      t.string :contract_number, limit: 20, comment: "契約No."
      t.stamp_fileds
    end
  end
end
