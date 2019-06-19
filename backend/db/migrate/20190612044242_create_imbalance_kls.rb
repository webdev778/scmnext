class CreateImbalanceKls < ActiveRecord::Migration[5.2]
  def change
    create_table :imbalance_kls, comment: "インバランスK値・L値" do |t|
      t.references :district, comment: "エリアID"
      t.date :start_date, comment: "開始日"
      t.decimal :k_value, precision: 10, scale: 4, comment: "K値"
      t.decimal :l_value, precision: 10, scale: 4, comment: "L値"
      t.stamp_fileds
    end
  end
end
