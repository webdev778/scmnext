class CreateBalancingGroupsCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :balancing_groups_companies, comment: "バランシンググループPPS関連" do |t|
      t.references :balancing_group, comment: "バランシンググループID"
      t.references :company, comment: "PPS ID"
      t.stamp_fileds
    end
  end
end