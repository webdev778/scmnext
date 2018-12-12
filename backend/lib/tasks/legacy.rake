namespace :legacy do
  desc "DB移行"
  task convert: :environment  do |task, args|
    # Legacy::Converter.convert(table_name: "tbl_area_supply_value", where_cond: "time >= '2018-06-01' and time < '2018-07-01' and priority = 1") do |from, to|
    #   to[:value] = from['value'] + from['interchange_value']
    #   to[:date] = from['time'].to_date.to_s
    #   to[:time_index_id] = ((from['time'].hour * 2) + 1) + (from['time'].min == 0 ? 0 : 1)
    #   to
    # end
    # exit
    Legacy::Converter.convert(table_name: "tbl_company")
    Legacy::Converter.convert(table_name: "tbl_district", where_cond: "id < 10")
    Legacy::Converter.convert(table_name: "tbl_contract_customer")
    Legacy::Converter.convert(table_name: "tbl_facility")
    Legacy::Converter.convert(table_name: "tbl_loss_rate_new")
    # Legacy::Converter.convert(table_name: "tbl_voltage")

    Legacy::Converter.convert(table_name: "tbl_actual_electrical_power", where_cond: "time >= '2018-06-01' and time < '2018-07-01'") do |from, to|
      to[:date] = from['time'].to_date.to_s
      to[:time_index_id] = ((from['time'].hour * 2) + 1) + (from['time'].min == 0 ? 0 : 1)
      to
    end
    Legacy::Converter.convert(table_name: "tbl_actual_electrical_low_power", where_cond: "time >= '2018-06-01' and time < '2018-07-01'", truncate: false) do |from, to|
       to[:date] = from['time'].to_date.to_s
       to[:time_index_id] = ((from['time'].hour * 2) + 1) + (from['time'].min == 0 ? 0 : 1)
       to
    end
  end

  desc "旧システムの縦横テーブルから変換定義ファイルを出力する"
  task make_file: :environment  do |task, args|
    table_name = ENV['TABLE_NAME']
    table_type = ENV['TYPE']
    if table_name.blank?
      puts "TABLE_NAME not specified."
      exit
    end
    if !["simple", "key_value"].include?(table_type)
      puts "unknown TYPE=#{table_type}(must simple or key_value)"
      exit
    end
    Legacy::Converter.make_file table_name, table_type
  end
end
