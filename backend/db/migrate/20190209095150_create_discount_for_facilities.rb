class CreateDiscountForFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_for_facilities, comment: "施設別割引" do |t|
      t.references "facility", comment: "設備ID"
      t.date "start_date", null: false, comment: "適用開始日"
      t.decimal "rate", null: false, precision: 10, scale: 4, comment: "割引率"
      t.stamp_fileds

      t.index [:facility_id, :start_date], name: :unique_index_on_business_logic, unique: true
    end
  end
end
