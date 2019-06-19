class RenameTypoAndAddAnyFieldsToFitPlan < ActiveRecord::Migration[5.2]
  def change
    remove_column :occto_fit_plans, "fit_recept_stat", :string, after: "stat", limit: 2, comment: "受付ステータス"
    add_column :occto_fit_plans, "fit_receipt_stat", :string, after: "stat", limit: 2, comment: "受付ステータス"
    add_index :occto_fit_plans, [:fit_id_text], name: :fit_id_text, unique: true
    remove_column :occto_fit_plans, "last_update_datetime_text", :string, after: "fit_receipt_stat", limit: 17, comment: "最終更新日時(テキスト)"
    add_column :occto_fit_plans, "occto_last_update_datetime", :datetime,  after: "fit_receipt_stat", comment: "広域最終更新日時:ミリ秒単位"
    add_column :occto_fit_plans, "occto_submit_datetime", :datetime, after: "occto_last_update_datetime", comment: "広域送信日時:秒単位"
    add_column :occto_fit_plans, "ottot_create_datetime", :datetime, after: "occto_submit_datetime", comment: "広域作成日時:秒単位"
  end
end
