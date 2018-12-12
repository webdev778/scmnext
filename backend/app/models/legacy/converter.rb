class Legacy::Converter < ActiveRecord::Base
  self.establish_connection(:legacy)

  def self.convert(options = {})

    options = {table_name: nil, where_cond: nil, truncate: true}.merge(options)
    config = YAML.load_file(Rails.root.join("config/legacy_convert/#{options[:table_name]}.yml")).with_indifferent_access
    fields = config[:fields].select{|from, to| not(to.nil?)}
    target_model = config[:target_model].constantize
    data_count = count_data(options[:table_name], config[:table_type], options[:where_cond])
    slice_num = 100000
    puts "get data from #{options[:table_name]}(count=#{data_count})"
    if options[:truncate]
      target_model.connection.execute("TRUNCATE #{target_model.table_name}")
    end
    slice_count = (data_count / slice_num).ceil
    slice_count = 1 if slice_count == 0
    slice_count.times.each do |i|
      offset = i == 0 ? 0 : (i * slice_num) + 1
      puts "limit=#{slice_num},offset=#{offset}"
      legacy_data = get_data(options[:table_name], config[:table_type], options[:where_cond], slice_num, offset ).to_hash
      import_data = legacy_data.map do |legacy_row|
        converted_row = fields.map{|from, to| [to, legacy_row[from]]}.to_h
        converted_row = yield(legacy_row, converted_row) if block_given?
        target_model.new converted_row
      end
      target_model.import import_data
    end
  end

  def self.make_file(table_name, table_type)
    output_filename = Rails.root.join("config/legacy_convert/#{table_name}.yml")
    if File.exist?(output_filename)
      puts "file already exists"
      exit
    end
    File.open(output_filename, mode: "w") do |f|
      f.puts "target_model:"
      f.puts "fields:"
      case table_type
      when "simple"
        p self.connection.query("desc #{table_name}")
        self.connection.query("desc #{table_name}").each do |row|
          f.puts "  #{row[0]}:"
        end
      when "key_value"
        dynamic_filed_names(table_name).each do |field|
          f.puts "  #{field}:"
        end
      end
    end
  end

  private
  def self.count_data(table_name, table_type, where_cond)
    self.connection.select_value( get_select_sql(table_name, table_type, where_cond, true) )
  end

  def self.get_data(table_name, table_type, where_cond, limit, offset)
    self.connection.select_all( get_select_sql(table_name, table_type, where_cond, false, limit, offset) )
  end

  def self.get_select_sql(table_name, table_type, where_cond, count, limit=nil, offset=nil)
    sql = count ? "SELECT count(*) " : "SELECT * ";
    case table_type
    when "simple"
      sql << " FROM #{table_name} AS target"
    when "key_value"
      sql << " FROM (#{get_table_sql(table_name)}) AS target"
    else
      raise "invalid table_type=#{table_type}"
    end
    unless (where_cond.blank?)
      sql << " WHERE #{where_cond}"
    end
    if !limit.nil? and !offset.nil?
      sql << " LIMIT #{limit} OFFSET #{offset}"
    end
    sql
  end

  def self.get_table_sql(table_name)
    fields = ['key_table.id AS id', 'key_table.tbl_account_id AS tbl_account_id']
    dynamic_filed_names(table_name).each do |field_name|
      fields << "MAX(IF(value_table.column_name='#{field_name}', value_table.value, NULL)) AS #{field_name}"
    end
    <<-EOS
      SELECT
        #{fields.join(',')}
      FROM
        #{table_name} key_table
      INNER JOIN
        #{table_name}_columns value_table
        ON key_table.id = value_table.row_id
      GROUP BY key_table.id
    EOS
  end

  def self.dynamic_filed_names(table_name)
    self.connection.select_all("select field from tbl_sys_item_meta_data where table_name = '#{table_name}'").rows.flatten
  end

end
