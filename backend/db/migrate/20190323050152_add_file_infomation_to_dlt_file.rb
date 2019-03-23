class AddFileInfomationToDltFile < ActiveRecord::Migration[5.2]
  def change
    add_column :dlt_files, :voltage_mode, :integer, limit: 1, after: "setting_id", comment: "電圧モード"
    add_column :dlt_files, :data_type, :integer, limit: 1, after: "voltage_mode", comment: "データ種別"
    add_column :dlt_files, :record_date, :date, after: "data_type", comment: "記録日:速報値の場合は、取得開始年月日、確定値の場合は検針日"
    add_column :dlt_files, :record_time_index_id, :integer, limit: 2, after: "record_date", comment: "記録時間枠ID:当日データのみ"
    add_column :dlt_files, :revision, :integer, limit: 2, after: "record_time_index_id", comment: "更新番号"
    add_column :dlt_files, :section_number, :integer, limit: 4, after: "record_time_index_id", comment: "分割番号"
    unless reverting?
      Dlt::File.includes(:content_blob, :content_attachment).find_each do |file|
         file.send("set_file_information")
         file.save
      end
    end
  end
end
