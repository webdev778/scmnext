class CreateOcctoPlanByBgMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_plan_by_bg_members, comment: "広域需要調達計画(翌日)BGメンバー別データ" do |t|
      t.references "plan", comment: "広域需要調達計画(翌日)ID"
      t.references "bg_member", comment: "BGメンバーID"
      t.stamp_fileds
      t.index [:plan_id, :bg_member_id], name: :unique_index_on_business, unique: true
    end
  end
end
