namespace :occto do
  namespace :plan do
    namespace :tomorrow do
      desc '翌日需要・調達計画取込'
      task import: :environment do |_task, _args|
        raise '取込対象となるファイルを環境変数TARGETで指定してください。' if ENV['TARGET'].nil?
        Occto::Plan.import_data(ENV['TARGET'])
      end

      desc '翌日需要・調達計画取込(旧システムより)'
      task import_from_legacy: :environment do |_task, _args|
        target_date = determine_target_date(Date.yesterday)
        BalancingGroup.find_each do |bg|
          Legacy::TblAreaSupplyValue.generate_position_data(bg.id, target_date)
        end
      end
    end
  end
end
