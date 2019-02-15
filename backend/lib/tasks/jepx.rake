namespace :jepx do

  namespace :download do
    desc "JEPXインバランスβ値取込"
    task imbalance_beta: :environment do |task, args|
      Jepx::ImbalanceBeta.import
    end

    desc "JEPXスポット市場取引結果取込"
    task spot_trade: :environment do |task, args|
      date = determine_target_date(nil)
      Jepx::SpotTrade.import(date)
    end
  end
end