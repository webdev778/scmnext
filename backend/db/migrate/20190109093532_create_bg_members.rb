class CreateBgMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :bg_members, comment: "BGメンバー" do |t|
      t.references :balancing_group, comment: "バランシンググループID"
      t.references :company, comment: "PPS ID"
      t.stamp_fileds
    end
  end
end
