class CreateOcctoFitPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_fit_plans, comment: "広域発電販売計画(翌日)" do |t|
      t.references :power_generator_group, comment: "発電BG ID"
      t.date :date, null: false, index: true, comment: "日付"
      t.datetime :initialized_at, default: nil, comment: "初期化日時"
      t.datetime :received_at, default: nil, comment: "取得日時"
      t.datetime :send_at, default: nil, comment: "送信日時"
      t.string :fit_id_text, default: nil, limit: 23, comment: "FIT ID(テキスト)"
      t.string :stat, default: nil, limit: 1, comment: "ステータス"
      t.string :fit_recept_stat, default: nil, limit: 2, comment: "受付ステータス"
      t.string :last_update_datetime_text, limit: 17, comment: "最終更新日時(テキスト)"
      t.stamp_fileds
    end
  end
end
