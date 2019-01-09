namespace :dlt do


  desc "30分データダウンロード"
  task download: :environment do |task, args|
    Dlt::File.download
  end

  namespace :import do
    desc "当日データを速報値テーブルへ取込む"
    task today: :environment do |task, args|
      (1..48).each do |i|
        PowerUsagePreliminary.import_from_dlt(1, 1, Date.today, i)
      end
    end

    desc "過去データを速報値テーブルへ取込む"
    task past: :environment do |task, args|
      PowerUsagePreliminary.import_from_dlt(1, 1, Date.today, i)
    end

    desc "確定使用量データを確定値テーブルへ取込む"
    task fixed: :environment do |task, args|
      PowerUsageFixed.import_data(1, 1)
    end
  end
end
