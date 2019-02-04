namespace :dlt do


  desc "30分データダウンロード"
  task download: :environment do |task, args|
    Dlt::File.download do |filename|
      1.month.before(Date.today) < DateTime.strptime(filename[6, 8], "%Y%m%d")
    end
  end

  #
  # テーブルへのインポート処理
  #
  namespace :import do
    def determine_target_date(default_date)
      ENV['DATE'] ? ENV['DATE'].in_time_zone : default_date
    end

    desc "当日データを速報値テーブルへ取込む"
    task today: :environment do |task, args|
      target_date = determine_target_date(Date.today)
      logger.debug("処理日:#{target_date}")
      (1..48).each do |i|
        PowerUsagePreliminary.import_today_data(1, 1, target_date, i)
      end
    end

    desc "過去データを速報値テーブルへ取込む"
    task past: :environment do |task, args|
      target_date = determine_target_date(Date.yesterday)
      logger.debug("処理日:#{target_date}")
      PowerUsagePreliminary.import_past_data(1, 1, target_date)
    end

    desc "確定使用量データを確定値テーブルへ取込む"
    task fixed: :environment do |task, args|
      PowerUsageFixed.import_data(1, 1)
    end
  end
end