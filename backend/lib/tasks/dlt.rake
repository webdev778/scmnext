namespace :dlt do
  desc '30分データダウンロード'
  task download: :environment do |_task, _args|
    if ENV['FROM']
      # FROMが指定されていた場合はその日付までを取得する
      Dlt::File.download do |filename|
        ENV['FROM'].in_time_zone < DateTime.strptime(filename[6, 8], '%Y%m%d')
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
      target_date = determine_target_date(Date.today)
      force = ENV['FORCE'].present? || ENV['FORCE'] == 'true'
      setting_id = ENV['SETTING_ID'].present? ? ENV['SETTING_ID'].to_i : nil
      time_index_id = ENV['TIME_INDEX'].present? ?  ENV['TIME_INDEX'].to_i : nil
      logger.info("処理日:#{target_date}")
      if time_index_id
        logger.info("時間枠:#{time_index_id}")
        Dlt::Setting.filter_state_active.filter_id_unless_nil(setting_id).find_each do |setting|
          PowerUsagePreliminary.import_today_data(setting, target_date, time_index_id, force)
        end
      else
        Dlt::Setting.filter_state_active.filter_id_unless_nil(setting_id).find_each do |setting|
          (1..48).each do |i|
            PowerUsagePreliminary.import_today_data(setting, target_date, i, force)
          end
        end
      end
    end

    desc '過去データを速報値テーブルへ取込む'
    task past: :environment do |_task, _args|
      target_date = determine_target_date(Date.yesterday)
      force = ENV['FORCE'].present? || ENV['FORCE'] == 'true'
      setting_id = ENV['SETTING_ID'].present? ? ENV['SETTING_ID'].to_i : nil
      logger.info("処理日:#{target_date}")
      Dlt::Setting.filter_state_active.filter_id_unless_nil(setting_id).find_each do |setting|
        PowerUsagePreliminary.import_past_data(setting, target_date, force)
      end
    end

    desc '確定使用量データを確定使用量テーブルに取り込む'
    task fixed: :environment do |_task, _args|
      target_date = determine_target_date(Date.yesterday)
      force = ENV['FORCE'].present? || ENV['FORCE'] == 'true'
      setting_id = ENV['SETTING_ID'].present? ? ENV['SETTING_ID'].to_i : nil
      logger.info("処理日:#{target_date}")
      Dlt::Setting.filter_state_active.filter_id_unless_nil(setting_id).find_each do |setting|
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
      start_date = ENV['FROM'].present? ?  ENV['FROM'].to_date : 1.month.before(Date.today).beginning_of_month
      end_date = ENV['TO'].present? ? ENV['TO'].to_date : start_date.end_of_month
      (start_date..end_date).each do |date|
        PowerUsageFixed.import_data(date)
      end

    end
  end
end
