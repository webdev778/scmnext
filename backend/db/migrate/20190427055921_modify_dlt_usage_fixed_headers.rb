class ModifyDltUsageFixedHeaders < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute "truncate dlt_usage_fixed_headers"
        execute "truncate dlt_usage_fixed_details"
      end
    end
    add_column :dlt_usage_fixed_headers, "information_type_code", :string, null: false, default: nil, limit: 4, after: :file_id, comment: '情報区分コード'
    add_column :dlt_usage_fixed_headers, "sender_code", :string, null: false, default: nil, limit: 5, after: :month, comment: '送信者コード'
    add_column :dlt_usage_fixed_headers, "receiver_code", :string, null: false, default: nil, limit: 5, after: :sender_code, comment: '受信者コード'
    reversible do |dir|
      dir.up do
        change_column :dlt_usage_fixed_headers, "journal_code", :string, limit: 1, comment: "仕訳コード: 1:全量,2:部分"
      end
      dir.down do
        change_column :dlt_usage_fixed_headers, "journal_code", :integer, limit: 1, comment: "仕訳コード: 1:全量,2:部分"
      end
    end
    add_column :dlt_usage_fixed_headers, "record_date", :date, null: false, default: nil, after: :month, comment: '検針日'
    remove_reference :dlt_usage_fixed_headers, :"file", after: :id, comment: "ファイルID"
    add_index :dlt_usage_fixed_headers, [:information_type_code, :year, :month, :sender_code, :receiver_code, :supply_point_number, :journal_code], name: :unique_index_on_business, unique: true
  end
end
