class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "ユーザー" do |t|
      t.string "name", comment: "名前"
      t.string "password", comment: "パスワード"
      t.references "accesable", polymorphic: true, index: true
      t.stamp_fileds
    end
  end
end
