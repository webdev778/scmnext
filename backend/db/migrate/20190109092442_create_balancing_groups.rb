class CreateBalancingGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :balancing_groups, comment: "バランシンググループ" do |t|
      t.string "code", limit: 5, null: false, comment: "コード"
      t.string "name", limit: 40, null: false, comment: "名前"
      t.references "district", comment: "エリアID"
      t.references "leader_company", comment: "リーダーPPS ID"
      t.stamp_fileds
    end
  end
end
