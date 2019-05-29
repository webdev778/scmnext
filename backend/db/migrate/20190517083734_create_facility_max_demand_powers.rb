class CreateFacilityMaxDemandPowers < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_max_demand_powers, comment: "施設月別最大需要電力" do |t|
      t.references :facility, comment: "施設ID"
      t.integer :year, limit: 4, null: false, comment: "年"
      t.integer :month, limit: 2, null: false, comment: "月"
      t.decimal :value, precision: 5, comment: "値(最大需要電力kw)"
      t.stamp_fileds
      t.index [:facility_id, :year, :month], name: :unique_index_for_business, unique: true
    end
  end
end
