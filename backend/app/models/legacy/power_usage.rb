class Legacy::PowerUsage
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :facility_id, :integer
  attribute :value, :decimal

  class << self
    #
    # 指定された会社、エリア、日付における新旧比較を行う
    #
    def summary(company_id, disctrict_id, date)
      next_high = PowerUsagePreliminary
        .where(
          'facility_groups.voltage_type_id' => [1, 2]
        )
        .where(
          'facility_groups.district_id' => disctrict_id,
          'facility_groups.company_id' => company_id,
          'date' => date
        )
        .total_by_time_index
      next_low = PowerUsagePreliminary
        .where.not(
          'facility_groups.voltage_type_id' => [1, 2]
        )
        .where(
          'facility_groups.district_id' => disctrict_id,
          'facility_groups.company_id' => company_id,
          'date' => date
        )
        .total_by_time_index
      legacy_high = Legacy::TblActualElectricalPower
        .filter_by_date(date)
        .where(pps_id: company_id, district_id: disctrict_id)
        .where("power > 0")
        .distinct
        .group(:time)
        .sum(:power)
        .map{|k, v| [(k.hour * 2) + (k.min / 30) + 1, v]}.to_h
      legacy_low = Legacy::TblActualElectricalLowPower
       .filter_by_date(date)
        .where(pps_id: company_id, district_id: disctrict_id)
        .where("power > 0")
        .distinct
        .group(:time)
        .sum(:power)
        .map{|k, v| [(k.hour * 2) + (k.min / 30) + 1, v]}.to_h
      (1..48).map do |time_index|
        next_high[time_index] ||= 0
        next_low[time_index] ||= 0
        legacy_high[time_index] ||= 0
        legacy_low[time_index] ||= 0
        [
          time_index,
          {
            next_high: next_high[time_index].to_f,
            next_low: next_low[time_index].to_f,
            next_total: (next_high[time_index] + next_low[time_index]).to_f,
            legacy_high: legacy_high[time_index].to_f,
            legacy_low: legacy_low[time_index].to_f,
            legacy_total: (legacy_high[time_index] + legacy_low[time_index]).to_f
          }
        ]
      end
    end

    #
    # 指定された会社、エリア、日付、時間枠における施設別の新旧比較を行う
    # (現行は低圧Gが2重計上されているので、この値が正)
    #
    def detail(company_id, disctrict_id, date, time_index_id)
      next_detail = PowerUsagePreliminary
        .eager_load(:facility_group)
        .where(
          'facility_groups.district_id' => disctrict_id,
          'facility_groups.company_id' => company_id,
          'date' => date,
          'time_index_id' => time_index_id
        )
        .map do |row|
          [
            row.facility_group_id,
            row.value
          ]
        end.to_h

      legacy_detail = Legacy::TblActualElectricalPower
        .filter_by_date_and_time_index_id(date, time_index_id)
        .where(pps_id: company_id, district_id: disctrict_id)
        .where("power > 0")
        .map do |row|
          [
            row.customer_id,
            row.power
          ]
        end.to_h
      all_facility_ids = next_detail.keys | legacy_detail.keys
      all_facility_names = FacilityGroup.where(id: all_facility_ids).pluck(:id, :name).to_h
      all_facility_ids.map do |facility_id|
        next_value = (next_detail[facility_id] ? next_detail[facility_id] : 0).to_f
        legacy_value = (legacy_detail[facility_id] ? legacy_detail[facility_id] : 0).to_f
        [
          facility_id,
          all_facility_names[facility_id],
          next_value,
          legacy_value,
          next_value - legacy_value
        ]
      end << all_facility_ids.reduce([nil, nil, 0, 0, 0]) do |total, facility_id|
        next_value = (next_detail[facility_id] ? next_detail[facility_id] : 0).to_f
        legacy_value = (legacy_detail[facility_id] ? legacy_detail[facility_id] : 0).to_f
        total[2] += next_value
        total[3] += legacy_value
        total[4] += (next_value - legacy_value )
        total
      end
    end

  end
end
