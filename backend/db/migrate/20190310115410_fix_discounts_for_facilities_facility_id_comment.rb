class FixDiscountsForFacilitiesFacilityIdComment < ActiveRecord::Migration[5.2]
  def up
    change_column :discounts_for_facilities, :facility_id, :bigint, comment: "施設ID"
  end

  def down
    change_column :discounts_for_facilities, :facility_id, :bigint, comment: "設備ID"
  end
end
