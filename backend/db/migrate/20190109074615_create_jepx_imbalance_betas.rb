class CreateJepxImbalanceBetas < ActiveRecord::Migration[5.2]
  def change
    create_table :jepx_imbalance_betas, comment: "JEPXインバランスβ値" do |t|
      t.integer "year", limit: 4, null: false, comment: "年"
      t.integer "month", limit: 2, null: false, comment: "月"
      t.references "district", comment: "エリアID"
      t.decimal "value", precision: 5, scale: 2, comment: "値"
      t.stamp_fileds
      t.index [:year, :month, :district_id], name: :unique_index_on_business, unique: true
    end
  end
end
