require 'erb'

def table_name_jp(model_class)
  table_options = model_class.connection.table_options(model_class.table_name)
  table_options[:comment]
end

def field_to_screen_item(target_model, fieldname)
  stamp_fields = {
    created_by: "作成者",
    created_at: "作成日時",
    updated_by: "更新者",
    updated_at: "更新日時",
  }
  column = target_model.columns_hash[fieldname]
  return nil if column.nil?

  screen_item = {}
  screen_item[:key] = fieldname
  if stamp_fields[fieldname.to_sym]
    screen_item[:label] = stamp_fields[fieldname.to_sym]
  elsif column.comment
    screen_item[:label] = column.comment
  else
    screen_item[:label] = fieldname
  end
  screen_item
end

def association_to_screen_item(target_model, association_refrection)
  foreign_column = target_model.columns_hash[association_refrection.foreign_key]
  screen_item = {}
  screen_item[:key] = "#{association_refrection.name}.name"
  screen_item[:label] = foreign_column.comment.sub(/ID$/, '名')
  screen_item
end

def association_to_extra_io(target_model, association_refrection)
  extra_io = {}
  extra_io[:table_name_jp] = table_name_jp(association_refrection.klass)
  extra_io[:table_name_real] = association_refrection.klass.table_name
  extra_io[:description] = "IDを#{association_refrection.foreign_key}と外部結合"
  extra_io
end

def write_to_file(filename, content)
  File.open(filename, "w").write(content)
end

desc '画面仕様書生成'
task spec: :environment do |_task, _args|
  document_root = (Rails.root.join("documents/asciidoc/src"))
  erb_header = ERB.new(File.open(Rails.root.join("lib/tasks/spec_header.adoc.erb")).read, nil, "%-")
  erb_index = ERB.new(File.open(Rails.root.join("lib/tasks/spec_pages_index.adoc.erb")).read, nil, "%-")
  erb_list = ERB.new(File.open(Rails.root.join("lib/tasks/spec_pages_list.adoc.erb")).read, nil, "%-")
  erb_show = ERB.new(File.open(Rails.root.join("lib/tasks/spec_pages_show.adoc.erb")).read, nil, "%-")
  content = erb_header.result(binding)
  @files = []

  [
    BalancingGroup,
    BgMember,
    Company,
    Consumer,
    Contract,
    ContractBasicCharge,
    ContractItem,
    ContractItemGroup,
    ContractMeterRate,
    DiscountsForFacility,
    District,
    DistrictLossRate,
    Dlt::File,
    Dlt::Setting,
    # Dlt::UsageFixedHeader,
    Facility,
    FacilityGroup,
    FuelCostAdjustment,
    JbuContract,
    Jepx::ImbalanceBeta,
    Jepx::SpotTrade,
    Resource,
    TimeIndex,
    User,
    VoltageType,
    WheelerCharge,
    Holiday
  ].each do |target_model|
    puts target_model.class_name
    @main_table_name_jp = table_name_jp(target_model)
    @table_name_real = target_model.table_name

    # 一覧画面仕様
    @program_name = "#{@main_table_name_jp}一覧画面"
    @extra_ios = []
    @screen_items = []
    @screen_items << field_to_screen_item(target_model, 'id')
    @screen_items << field_to_screen_item(target_model, 'name')
    target_model
      .reflect_on_all_associations
      .select { |reflection| reflection.belongs_to? }
      .each do |reflection|
        @extra_ios << association_to_extra_io(target_model, reflection)
        @screen_items << association_to_screen_item(target_model, reflection)
      end
    @screen_items.compact!

    @filename = "#{@program_name}.adoc"
    @files << @filename
    write_to_file(document_root.join('pages', @filename), erb_list.result(binding))

    # 詳細画面仕様
    foreign_key_map = target_model.reflect_on_all_associations.select(&:belongs_to?).map { |r| [r.foreign_key, r] }.to_h

    @program_name = "#{@main_table_name_jp}詳細画面"
    @extra_ios = []
    @screen_items = []
    target_model.columns.each do |column|
      desc = nil
      if foreign_key_map[column.name]
        @extra_ios << association_to_extra_io(target_model, foreign_key_map[column.name])
        desc = "関連テーブルの全データを取得しドロップダウンにセットする"
      end
      screen_item = field_to_screen_item(target_model, column.name)
      screen_item[:description] = desc unless desc.nil?
      @screen_items << screen_item
    end
    @filename = "#{@program_name}.adoc"
    @files << @filename
    write_to_file(document_root.join('pages', @filename), erb_show.result(binding))

    write_to_file(document_root.join('pages', 'index.adoc'), erb_index.result(binding))
  end
  File.open(document_root.join("index.adoc"), "w").write(content)
end
