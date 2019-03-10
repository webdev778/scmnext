class ChangeTableNameOfDiscountForFacilities < ActiveRecord::Migration[5.2]
  def change
    rename_table :discount_for_facilities, :discounts_for_facilities
  end
end
