namespace :spec do
  require 'erb'
  desc 'Phase2画面仕様書生成'
  task phase2: :environment do |_task, _args|
    base_dir = File.dirname(__FILE__)
    program_list = YAML.load_file(File.join(base_dir, 'phase2/program_list.yml'))

    template_book_index = ERB.new(File.open(File.join(base_dir, 'phase2/template_book_index.adoc.erb')).read, nil, "%-")
    template_chapter_index = ERB.new(File.open(File.join(base_dir, 'phase2/template_chapter_index.adoc.erb')).read, nil, "%-")

    document_root = Rails.root.join("documents/asciidoc/src/phase2")

    @categories = program_list.keys
    File.open(document_root.join("index.adoc"), "w").write(template_book_index.result(binding))
    @categories.each do |category_name|
      @chapter_name = category_name
      category_dir_name = document_root.join(category_name)
      Dir.mkdir(category_dir_name) unless Dir.exists?(category_dir_name)
      category_definition = program_list[category_name]
      @sections = category_definition['items']
      File.open(document_root.join("#{category_name}/index.adoc"), "w").write(template_chapter_index.result(binding))
      template_name = "template_spec_#{category_definition['type']}.adoc.erb"
      template_spec = ERB.new(File.open(File.join(base_dir, "phase2/#{template_name}")).read, nil, "%-")
      category_definition['items'].each do |title|
        @title = title
        File.open(document_root.join("#{category_name}/#{@title}.adoc"), "w").write(template_spec.result(binding))
      end
    end
  end
end
