class CreatePowerGenerators < ActiveRecord::Migration[5.2]
  def change
    create_table :power_generators, comment: "発電者" do |t|
      t.references :power_generator_group, comment: "発電BG ID"
      t.string :code, null: false, limit: 5, comment: "コード"
      t.string :name, null: false, comment: "名前"
      t.string :contract_number, limit: 20, comment: "契約No."
      t.integer :supply_max, comment: "最大量"
      t.stamp_fileds
    end
  end
end
