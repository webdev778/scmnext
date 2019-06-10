class RecreatePowerGeneratorGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :power_generator_groups, comment: "発電BG" do |t|
      t.references :resource, comment: "リソースID"
      t.string :name, comment: "名前"
      t.string :code, limit: 5, comment: "コード"
      t.string :contract_number, limit: 20, comment: "契約No."
      t.stamp_fileds
    end
    remove_reference :power_generators, :resources, after: "id", comment: "リソースID"
    add_reference :power_generators, :power_generator_group, after: "id", comment: "発電BG ID"
  end
end
