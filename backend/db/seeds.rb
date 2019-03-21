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
  if facility_group.save(validate: false) # 京葉が契約が無いために保存できないのでvalidationしない
    count += 1
  end
end
puts "#{count}件 更新しました。"

puts "低圧施設のうち、施設グループ登録されていないものを登録"
facility_not_grouped = Facility
                       .includes([{ supply_point: :facility_group }, :consumer])
                       .where("facility_groups.id" => nil)
                       .where.not("consumers.id" => nil)

facility_not_grouped.group_by do |facility|
  [
    facility.consumer.company_id,
    facility.district_id,
    (facility.contracts.first.nil? ? nil : facility.contracts.first.id),
    facility.voltage_type_id,
    facility.contract_capacity_for_facility_group
  ]
end
                    .each do |keys, facilities|
  company_id, district_id, contract_id, voltage_type_id, contract_capacity = keys
  facility_group = FacilityGroup.create(
    name: facilities.first.name_for_facility_group,
    company_id: company_id,
    district_id: district_id,
    contract_id: contract_id,
    voltage_type_id: voltage_type_id,
    contract_capacity: contract_capacity
  )
  SupplyPoint.where(id: facilities.map { |facility| facility.supply_point.id }).update(facility_group_id: facility_group.id)
end
