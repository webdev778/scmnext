class CreateDltFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :dlt_files, comment: "ダウンロードファイル" do |t|
      t.references :setting, comment: "ダウンロード設定ID"
      t.integer :state, null: false, default: 0, comment: "状態:(0:未取込,1:取込完了,2:処理中,3:一部取込(エラーあり))"
      t.stamp_fileds
    end
  end
end
