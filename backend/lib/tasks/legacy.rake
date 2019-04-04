namespace :legacy do
  def merge_yaml(filename)
    parentdir = File.dirname(filename)
    Dir.mkdir(parentdir) unless Dir.exist?(parentdir)
    config = File.exist?(filename) ? YAML.load_file(filename) : {}
    raise 'Invalid yaml file. Please check format' unless config

    config = yield(config)
    File.open(filename, mode: 'w') do |f|
      YAML.dump(config, f)
    end
  end

  def write_legacy_table_definition(table_name, type, fields)
    merge_yaml(table_definition_path.join("#{table_name}.yml")) do |config|
      config.merge(
        table_name: table_name,
        table_type: type,
        fields: fields
      )
    end
  end

  def write_convert_config(class_name, fields)
    merge_yaml(converter_path.join("#{class_name.underscore}.yml")) do |config|
      config[:truncate] ||= true
      config = config.merge(
        model_class: class_name
      )
      if config[:fields].nil?
        # 新定義の場合
        config[:sources] ||= [{}]
        config[:sources].each do |source|
          source[:fields] ||= {}
          source[:fields] = fields.map do |field_name|
            [field_name, source[:fields][field_name]]
          end.to_h
          source[:from] ||= nil
          source[:where] ||= nil
        end
      else
        # 旧定義の場合、新定義に置き換える
        config[:sources] ||= [{}]
        config[:sources][0]
        %i[fields from where joins].each do |item_name|
          unless config[item_name].nil?
            config[:sources][0][item_name] = config[item_name]
            config.delete(item_name)
          end
        end
      end
      config
    end
  end

  def legacy_connection
    Legacy.connection
  end

  def my_connection
    ActiveRecord::Base.connection
  end

  def table_definition_path
    Rails.root.join('config/legacy_convert/legacy_tables')
  end

  def get_table_definition(table_name)
    path = table_definition_path.join("#{table_name}.yml")
    raise "Can't find #{table_name} yml file." unless File.exist?(path)

    YAML.load_file(path)
  end

  def table_object(table_name, alias_name = nil)
    config = get_table_definition(table_name)
    alias_name ||= table_name
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
               .as(alias_name)
    when :simple
      Arel::Table.new(table_name).alias(alias_name)
    else
      raise "invalid table_type for #{table_name}"
    end
  end

  def converter_path
    Rails.root.join('config/legacy_convert/converter')
  end

  #
  # 個別の変換処理
  #
  def convert(yaml_path)
    config = YAML.load_file(yaml_path)
    return if config[:skip]

    legacy_con = legacy_connection
    my_con = my_connection
    puts config[:model_class]
    model_class = config[:model_class].constantize
    model_class.connection.execute("TRUNCATE #{model_class.table_name}") if config[:truncate]
    config[:sources]&.each do |source|
      table_obj = table_object(source[:from])
      select_manager = Arel::SelectManager.new
      select_manager = select_manager.from(table_obj)
      source[:joins]&.each do |join|
        join_table = table_object(join[:table], join[:as])
        case join[:type]
        when 'inner'
          join_type = Arel::Nodes::InnerJoin
        when 'outer'
          join_type = Arel::Nodes::OuterJoin
        else
          raise '結合はinnerまたはouterを指定してください。'
        end
        select_manager = select_manager.join(join_table, join_type).on(Arel.sql(join[:on]))
      end
      select_manager = select_manager.project(source[:fields].delete_if { |_k, v| v.blank? }.map { |k, v| Arel.sql(v).as(k) })
      select_manager = select_manager.where(Arel.sql(source[:where])) if source[:where].present?
      items = legacy_con.select_all(select_manager.to_sql).to_hash.map do |params|
        model_class.new params
      end
      if ENV['DEBUG']
        puts 'insert items'
        p items
      end
      result = model_class.import items
      binding.pry unless result.failed_instances.empty?
    end
    # その他データ登録
    if config[:extra]
      column_names = model_class.column_names
      config[:extra].each do |extra_item|
        model_instance = extra_item[:cond].nil? ? model_class.new : model_class.find_or_initialize_by(extra_item[:cond])
        extra_item[:fields].each do |field_name, value|
          if column_names.include?(field_name)
            # カラム定義があれば値としてセット
            model_instance[field_name] = value
          else
            # カラム定義がなければ添付ファイル扱い
            path = Rails.root.join('config/legacy_convert', value)
            if File.exist?(path)
              model_instance.send(field_name).attach(io: File.open(path, 'r'), filename: path.basename)
            else
              puts "file:#{path} not found."
            end
          end
        end
        model_instance.save!
      end
    end
  end

  #
  # 全ての定義ファイルに対して変換処理を行う
  #
  def convert_all
    Dir.glob("#{converter_path}/**/*.yml").sort.each do |yaml_path|
      convert yaml_path
    end
  end

  #
  # 施設グループデータの修正
  #
  def fix_facility_group
    # 電圧区分が正しく取れないものについて、補正する
    logger.info "低圧グループ(99)の電圧区分を本来の電圧区分に付け替える"
    count = 0
    FacilityGroup.all.where(voltage_type_id: 99).each do |facility_group|
      # 京葉は名前から区分を推測
      if facility_group.company_id == 21
        facility_group.voltage_type_id = case facility_group.name
        when /従量電灯A/
          4
        when /従量電灯B/
          5
        when /従量電灯C/
          6
        when /低圧/
          3
        else
          raise "電圧区分が判別できません。"
        end
      else
        # その他は契約から区分を取得
        facility_group.voltage_type_id = facility_group.contract.voltage_type_id
      end
      if facility_group.save(validate: false) # 京葉が契約が無いために保存できないのでvalidationしない
        count += 1
      end
    end
    logger.info "#{count}件 更新しました。"

    logger.info "施設グループに登録されていない低圧施設を探し、施設グループを作成"
    count = 0
    facility_not_grouped = Facility
      .includes([{ supply_point: :facility_group }, :consumer])
      .where("facility_groups.id" => nil)
      .where.not("consumers.id" => nil)

    facility_not_grouped
      .group_by do |facility|
        [
          facility.consumer.company_id,
          facility.district_id,
          (facility.contracts.first.nil? ? nil : facility.contracts.first.id),
          facility.voltage_type_id,
          facility.contract_capacity_for_facility_group
        ]
      end
      .each do |keys, facilities|
        company_id, district_id, contract_id, voltage_type_id, contract_capacity = keys
        facility_group = FacilityGroup.create(
          name: facilities.first.name_for_facility_group,
          company_id: company_id,
          district_id: district_id,
          contract_id: contract_id,
          voltage_type_id: voltage_type_id,
          contract_capacity: contract_capacity
        )
        count += 1
        SupplyPoint.where(id: facilities.map { |facility| facility.supply_point.id }).update(facility_group_id: facility_group.id)
      end
      logger.info "#{count}件 登録しました。"
    end

  desc '施設グループデータを修正する'
  task fix_facility_group: :environment do |_task, _args|
    fix_facility_group
  end

  desc 'DB移行'
  task convert: :environment do |_task, _args|
    if ENV['TARGET']
      yaml_file = ENV['TARGET']
      raise "指定された定義ファイル#{yaml_file}が見つかりません。" unless File.exist?(yaml_file)

      convert yaml_file
    else
      convert_all
      fix_facility_group
    end
  end

  namespace :generate do
    desc '新システムの変換定義の雛形を作成'
    task converter: :environment do |_task, _args|
      Rails.application.eager_load!
      model_classes = ActiveRecord::Base.descendants.delete_if do |model_class|
        %w[ApplicationRecord Legacy].include?(model_class.to_s)
      end
      model_classes.each do |model_class|
        puts model_class.to_s
        write_convert_config(model_class.to_s, model_class.column_names)
      end
    end

    desc '旧システムのテーブル定義情報を作成'
    task legacy_tables: :environment do |_task, _args|
      connection = legacy_connection
      all_legacy_tables = connection.tables
      key_value_tables = connection.select_all('select table_name from tbl_sys_item_meta_data group by table_name').rows.flatten
      key_value_tables_exist, key_value_tables_not_exist = connection.select_all('select table_name from tbl_sys_item_meta_data group by table_name')
                                                                     .rows
                                                                     .flatten
                                                                     .partition do |table_name|
        all_legacy_tables.delete(table_name) && all_legacy_tables.delete("#{table_name}_columns")
      end
      # key/valueの定義を出力
      key_value_tables_exist.each do |table_name|
        fields = connection.select_all("select field from tbl_sys_item_meta_data where table_name = '#{table_name}'").rows.flatten
        write_legacy_table_definition(table_name, :key_value, fields)
      end

      # 通常の定義を出力
      all_legacy_tables.each do |table_name|
        fields = connection.query("desc #{table_name}").map { |row| row[0] }
        write_legacy_table_definition(table_name, :simple, fields)
      end
    end
  end
end
