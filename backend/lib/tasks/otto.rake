namespace :occto do
  namespace :plan do
    namespace :tomorrow do
      desc "翌日需要・調達計画取込"
      task import: :environment do |task, args|
        raise "取込対象となるファイルを環境変数TARGETで指定してください。" if ENV['TARGET'].nil?

        Occto::Plan.import_data(ENV['TARGET'])
      end
    end
  end
end
