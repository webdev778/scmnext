namespace :jepx do
  namespace :download do
    desc 'JEPXインバランスβ値取込'
    task imbalance_beta: :environment do |_task, _args|
      logger.info "JEPXインバランスβ値データを取り込みます"
      Jepx::ImbalanceBeta.import_data
    end

    desc 'JEPXスポット市場取引結果取込'
    task spot_trade: :environment do |_task, _args|
      years = []
      if ENV['YEAR']
        # パラメータ指定時はパラメータの年度を
        years << ENV['YEAR'].to_i
      else
        # パラメータ未指定時は
        # 4～5月は前年度と当年度
        # それ以外は当年度のデータを取得
        today = Date.today
        case
        when (1..3).include?(today.month)
          years << today.year - 1
        when (4..5).include?(today.month)
          if [4, 5].include?(today.month) and not Jepx::SpotTrade.where(date: Date.new(today.year, 3, 1).end_of_month).exists?
            years << today.year - 1
          end
          years << today.year
        when
          years << today.year
        end
      end
      years.each do |year|
        logger.info "#{year}年度のJEPX市場取引結果データを取り込みます"
        Jepx::SpotTrade.import_data(year)
      end
    end
  end
end
