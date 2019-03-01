# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 移行データを調整するための処理をひとまずここに記述する

# 電圧区分が正しく取れないものについて、補正する
puts "低圧グループ99の電圧区分の付け替え"
count = 0
FacilityGroup.all.where(voltage_type_id: 99).each do |facility_group|
  if facility_group.company_id != 21
    facility_group.voltage_type_id = facility_group.contract.voltage_type_id
  else
    facility_group.voltage_type_id = case facility_group.name
    when /従量電灯A/
      4
    when /従量電灯B/
      5
    when /従量電灯C/
      6
    when /低圧/
      3
    else
      raise "電圧区分が判別できません。"
    end
  end
  if facility_group.save(validate: false) # 京葉が契約がなくて保存できないのでvalidatinoしない
    count += 1
  end
end
puts "#{count}件 更新しました。"
