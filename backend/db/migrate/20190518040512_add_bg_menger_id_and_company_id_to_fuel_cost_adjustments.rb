class AddBgMengerIdAndCompanyIdToFuelCostAdjustments < ActiveRecord::Migration[5.2]
  def change
    add_reference :fuel_cost_adjustments, :bg_member, after: :district_id, comment: "BGメンバーID"
    add_reference :fuel_cost_adjustments, :company, after: :id, comment: "PPS ID"
  end
end
