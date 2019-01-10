class CreateOcctoPlanByCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :occto_plan_by_companies, comment: "広域需要調達計画(翌日)PPS別データ" do |t|
      t.references "plan", comment: "広域需要調達計画(翌日)ID"
      t.references "company", comment: "PPS ID"
      t.stamp_fileds
      t.index [:plan_id, :company_id], name: :unique_index_on_business, unique: true
    end
  end
end
