class ChangeJbuContractsReferenceFromBgMemberToResource < ActiveRecord::Migration[5.2]
  def change
    add_reference :jbu_contracts, :resource, after: :id, comment: "リソースID"
    remove_reference :jbu_contracts, :bg_member, after: :district_id, comment: "BGメンバーID"
  end
end
