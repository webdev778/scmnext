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
    merge_yaml(table_definition_path.join("#{table_name}.yml")) do |config|
      config.merge({
        table_name: table_name,
        table_type: type,
        fields: fields
      })
    end
  end

  def write_convert_config(class_name, fields)
    merge_yaml(converter_path.join("#{class_name.underscore}.yml")) do |config|
      config = config.merge({
        model_class: class_name,
      })
      config[:fields] ||= {}
      fields.each do |field_name|
        config[:fields][field_name] ||= nil
      end
      config[:from] ||= 'base_table_name'
      config[:where] ||= '0 = 0'
      config
    end
  end

  def legacy_connection
    Legacy::Converter.connection
  end

  def my_connection
    ActiveRecord::Base.connection
  end

  def table_definition_path
    Rails.root.join("config/legacy_convert/legacy_tables")
  end

  def get_table_definition(table_name)
    YAML.load_file(table_definition_path.join("#{table_name}.yml"))
  end

  def table_object(table_name)
    config = get_table_definition(table_name)
    case config[:table_type]
    when :key_value
      key_table = Arel::Table.new(table_name)
      column_table = Arel::Table.new("#{table_name}_columns")
      projects = []
      projects << key_table[:id].as('id')
      projects << key_table[:tbl_account_id].as('tbl_account_id')
      config[:fields].each do |field|
        projects << Arel::Nodes::NamedFunction.new(
          'MAX',
          [
            Arel::Nodes::NamedFunction.new(
              'IF',
              [
                column_table[:column_name].eq(field),
                column_table[:value],
                Arel::Nodes.build_quoted(nil)
              ]
            )
          ]
        ).as(field)
      end
      key_table.project(projects)
      .join(
        column_table, Arel::Nodes::InnerJoin
      ).on(key_table[:id].eq(column_table[:row_id]))
      .group(key_table[:id])
      .as(table_name)
    when :simple
      Arel::Table.new(table_name).as(table_name)
    else
      raise "invalid table_type for #{table_name}"
    end
  end

  def converter_path
    Rails.root.join("config/legacy_convert/converter")
  end


  desc "DB移行"
  task convert: :environment  do |task, args|
    legacy_con = legacy_connection
    my_con = my_connection
    Dir.glob("#{converter_path}/*.yml") do |yaml_path|
      config = YAML.load_file(yaml_path)
      next if config[:skip]
      puts config[:model_class]
      table_obj = table_object(config[:from])
      select_manager = Arel::SelectManager.new
      select_manager = select_manager.from(table_obj)
      select_manager = select_manager.project(config[:fields].delete_if{|k, v| v.empty?}.map{|k, v| Arel.sql(v).as(k)})
      select_manager = select_manager.where(Arel.sql(config[:where])) unless config[:where].blank?
      model_class = config[:model_class].constantize
      items = legacy_con.select_all(select_manager.to_sql).to_hash.map do |params|
        model_class.new params
      end
      model_class.import items
    end
  end

  desc "DB移行"
  task convert_old: :environment  do |task, args|
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
    connection = legacy_connection
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
