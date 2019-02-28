# == Schema Information
#
# Table name: power_usage_fixeds
#
#  id                :bigint(8)        not null, primary key
#  facility_group_id :bigint(8)        not null
#  date              :date             not null
#  time_index_id     :bigint(8)        not null
#  value             :decimal(10, 4)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class PowerUsageFixed < ApplicationRecord
  include PowerUsage

  class << self
    #
    # 確定使用量データから施設グループ単位の確定値を取得しテーブルにインポートする
    #
    def import_data(_company_id, _district_id, start_date, end_date)
      import_data = Dlt::UsageFixedDetail
                    .joins(usage_fixed_header: :supply_point)
                    .where(['date >= ? and date <= ?', start_date, end_date])
                    .distinct
                    .select([
                              :facility_group_id,
                              :date,
                              :time_index_id,
                              Arel.sql("SUM(CASE journal_code WHEN '2' THEN `dlt_usage_fixed_details`.`usage` ELSE `dlt_usage_fixed_details`.`usage_all` END) AS value")
                            ])
                    .group(:facility_group_id, :date, :time_index_id)
                    .as_json(except: :id)
      result = import import_data, on_duplicate_key_update: [:value]
    end
  end
end
