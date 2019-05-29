class DeleteBalancingGroupIdAndAddBgMemberIdToResources < ActiveRecord::Migration[5.2]
  def change
    add_reference :resources, :bg_member, after: :id, comment: "BGメンバーID"
    remove_reference :resources, :balancing_group, after: :id, comment: "バランシンググループID"
  end
end
