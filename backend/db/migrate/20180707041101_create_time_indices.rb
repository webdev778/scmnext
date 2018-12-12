class CreateTimeIndices < ActiveRecord::Migration[5.2]
  def change
    create_table :time_indices, commend: "時間枠" do |t|
      t.time "time", comment: "時間"
      t.stamp_fileds
    end
  end
end
