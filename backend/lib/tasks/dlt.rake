namespace :dlt do


  desc "30分データダウンロード"
  task download: :environment do |task, args|
    Dlt::File.download
  end

  task import: :environment do |task, args|
    (1..48).each do |i|
      PowerUsagePreliminary.import_from_dlt(1, 1, Date.today, i)
    end
  end
end
