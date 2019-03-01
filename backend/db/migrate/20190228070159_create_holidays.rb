class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays, comment: "休日" do |t|
      t.references "district", comment: "エリアID"
      t.date "date", comment: "日付"
      t.string "name", comment: "名称"
      t.stamp_fileds
    end
  end
end
