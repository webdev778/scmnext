namespace :pl do
  namespace :generate do
    desc "損益計算基本データ(速報値ベース)作成"
    task preliminary: :environment do |task, args|
      target_date = determine_target_date(Date.yesterday)
      Pl::BaseDatumPreliminary.generate target_date
    end

    desc "損益計算基本データ(確定値ベース)作成"
    task fixed: :environment do |task, args|
      target_date = determine_target_date(Date.yesterday)
      Pl::BaseDatumFixed.generate target_date
    end
  end
end
