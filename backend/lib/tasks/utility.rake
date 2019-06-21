namespace :utility do
  desc 'レイアウト修正'
  task fix_layout: :environment do |_task, _args|
    sh 'rubocop --fix-layout app lib'
  end

  desc '構文チェック'
  task lint: :environment do |_task, _args|
    sh 'rubocop --rails --auto-correct app lib'
  end

  desc 'yardによるドキュメント生成'
  task doc: :environment do |_task, _args|
    sh 'yard doc'
  end

  desc 'erdによるER図作成'
  task erd: :environment do |_task, _args|
    sh 'erd --filename=doc/ER図'
  end

  desc 'rspec実行'
  task rspec: :environment do |_task, _args|
    sh 'AUTODOC=1 rspec'
  end

  desc 'asciidoctorによるpdf作成'
  task asciidoc: [:environment, :rspec] do |_task, _args|
    #sh 'cd ../deploy && asciidoctor-pdf -r asciidoctor-diagram ./documents/asciidoc/src/phase1/index.adoc'
    sh 'cd ../deploy && asciidoctor-pdf -r asciidoctor-diagram ./documents/asciidoc/src/phase2/index.adoc'
  end

  desc '全て実行'
  task all: %i[fix_layout lint doc erd] do |_task, _args|
  end

  desc "モデルからカラム名取得"
  task get_column_names: :environment do |task, args|
    Rails.application.eager_load!
    models = ActiveRecord::Base.descendants.map do |model|
      next nil if model.abstract_class?
      model_fields = model.columns.map do |column|
        next nil if column.comment.nil?
        [column.name, column.comment]
      end.compact.to_h
      [model.name.downcase, model_fields]
    end.compact.to_h
    filename = Rails.root.join("config/locales", "ja_activerecord_default.yml")
    File.open(filename, "w") do |f|
      f.write({I18n.default_locale.to_s=>{"activerecord"=>{"attributes"=>models}}}.to_yaml)
    end
  end
  
end
