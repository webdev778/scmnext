class CreateDltSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :dlt_settings, comment: "ダウンロード設定" do |t|
      t.references :company, comment: "会社ID"
      t.references :district, comment: "エリアID"
      t.integer :state, null: false, default: 0, comment: "状態:(0:正常, 1:休止中)"
      t.timestamps
    end
  end
end
