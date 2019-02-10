class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources, comment: "リソース" do |t|
      t.references :balancing_group, comment: "バランシンググループID"
      t.string :type, null: false, comment: "種別"
      t.string :code, null: false, comment: "コード"
      t.string :name, null: false, comment: "名称"
      t.stamp_fileds
    end
  end
end
