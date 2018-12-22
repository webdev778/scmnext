namespace :legacy do

  def merge_yaml(filename)
    config = File.exist?(filename) ? YAML.load_file(filename) : {}
    raise "Invalid yaml file. Please check format" unless config
    config = yield(config)
    File.open(filename, mode: "w") do |f|
      YAML.dump(config, f)
    end
  end

  def write_legacy_table_definition(table_name, type, fields)
    merge_yaml(Rails.root.join("config/legacy_convert/legacy_tables/#{table_name}.yml")) do |config|
      config.merge({
        table_name: table_name,
        table_type: type,
        fields: fields
      })
    end
  end

  def write_convert_config(class_name, fields)
    merge_yaml(Rails.root.join("config/legacy_convert/converter/#{class_name.underscore}.yml")) do |config|
      config.merge({
        model_class: class_name,
      })
      config[:fields] ||= {}
      fields.each do |field_name|
        config[:fields][field_name] ||= ''
      end
      config[:from] ||= 'base_table_name'
      config[:where] ||= '0 = 0'
      config
    end
  end

  desc "DB移行"
  task convert2: :environment  do |task, args|
  end

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

  desc "新システムの変換定義の雛形を作成"
  task make_convert_config: :environment do |task, args|
    Rails.application.eager_load!
    model_classes = ActiveRecord::Base.descendants.delete_if do |model_class|
      ['ApplicationRecord', 'Legacy::Converter'].include?(model_class.to_s)
    end
    model_classes.each do |model_class|
      write_convert_config(model_class.to_s, model_class.column_names)
    end
  end

  desc "旧システムのテーブル定義情報を作成"
  task make_definitions: :environment do |task, args|
    ActiveRecord::Base.establish_connection(:legacy)
    connection = ActiveRecord::Base.connection
    all_legacy_tables = connection.tables
    key_value_tables = connection.select_all("select table_name from tbl_sys_item_meta_data group by table_name").rows.flatten
    key_value_tables_exist, key_value_tables_not_exist = connection.select_all("select table_name from tbl_sys_item_meta_data group by table_name")
      .rows
      .flatten
      .partition do |table_name|
        all_legacy_tables.delete(table_name) and all_legacy_tables.delete("#{table_name}_columns")
      end
    # key/valueの定義を出力
    key_value_tables_exist.each do |table_name|
      fields = connection.select_all("select field from tbl_sys_item_meta_data where table_name = '#{table_name}'").rows.flatten
      write_legacy_table_definition(table_name, :key_value, fields)
    end

    # 通常の定義を出力
    all_legacy_tables.each do |table_name|
      fields = connection.query("desc #{table_name}").map{|row| row[0]}
      write_legacy_table_definition(table_name, :simple, fields)
    end
  end
end
