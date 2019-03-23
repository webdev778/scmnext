namespace :dlt do
  desc '30分データダウンロード'
  task download: :environment do |_task, _args|
    if ENV['FROM']
      # FROMが指定されていた場合はその日付までを取得する
      Dlt::File.download do |filename|
        ENV['FROM'].in_timezone < DateTime.strptime(filename[6, 8], '%Y%m%d')
      end
    else
      Dlt::File.download
    end
  end

  #
  # XMLからテーブルへのインポート処理
  #
  namespace :import do
    desc '当日データを速報値テーブルへ取込む'
    task today: :environment do |_task, _args|
      target_date = determine_target_date(Date.yesterday)
      force = ENV['FORCE'].present? || ENV['FORCE'] == 'true'
      logger.info("処理日:#{target_date}")
      Dlt::Setting.filter_state_active.find_each do |setting|
        (1..48).each do |i|
          PowerUsagePreliminary.import_today_data(setting, target_date, i, force)
        end
      end
    end

    desc '過去データを速報値テーブルへ取込む'
    task past: :environment do |_task, _args|
      target_date = determine_target_date(Date.yesterday)
      force = ENV['FORCE'].present? || ENV['FORCE'] == 'true'
      logger.info("処理日:#{target_date}")
      Dlt::Setting.filter_state_active.find_each do |setting|
        PowerUsagePreliminary.import_past_data(setting, target_date, force)
      end
    end

    desc '確定使用量データを確定使用量テーブルに取り込む'
    task fixed: :environment do |_task, _args|
      target_date = determine_target_date(Date.yesterday)
      force = ENV['FORCE'].present? || ENV['FORCE'] == 'true'
      logger.info("処理日:#{target_date}")
      Dlt::Setting.filter_state_active.find_each do |setting|
        Dlt::UsageFixedHeader.import_data(setting, target_date, force)
      end
    end
  end

  #
  # 確定使用量の集計処理
  #
  namespace :summary do
    desc '確定使用量テーブルのデータを確定値テーブルへ取込む'
    task fixed: :environment do |_task, _args|
      start_date = Date.new(2018, 11, 1)
      Dlt::Setting.filter_state_active.find_each do |setting|
        PowerUsageFixed.import_data(setting.company_id, setting.district_id, start_date, start_date.end_of_month)
      end
    end
  end
end
