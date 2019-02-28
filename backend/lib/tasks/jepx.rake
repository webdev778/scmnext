namespace :jepx do

  namespace :download do
    desc "JEPXインバランスβ値取込"
    task imbalance_beta: :environment do |task, args|
      Jepx::ImbalanceBeta.import_data
    end

    desc "JEPXスポット市場取引結果取込"
    task spot_trade: :environment do |task, args|
      year = ENV['YEAR'] ? ENV['YEAR'].to_i : nil
      target_date = Date.today
      if year
        Jepx::SpotTrade.import_data(year)
      elsif [4, 5].include? target_date.month and Jepx::SpotTrade.where(date: Date(target_date.year, 3, 31)).exists?
        Jepx::SpotTrade.import_data(target_date.year)
        Jepx::SpotTrade.import_data(target_date.year - 1)
      else
        target_year = target_date.month >= 4 ? target_date.year : target_date.year - 1
        Jepx::SpotTrade.import_data(target_year)
      end
    end
  end
end