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
    def import_data(setting, start_date, end_date)
      target_name = "#{setting.bg_member.company.name} #{setting.bg_member.balancing_group.district.name}"
      logger.info("[#{target_name}]の確定値集計処理を開始 (期間 #{start_date}～#{end_date}")
      self.connection.execute(generate_select_insert_sql(start_date, end_date))
    end

    private
    def generate_select_insert_sql(start_date, end_date)
      insert_manager = Arel::InsertManager.new
      insert_manager.select(Arel.sql(generate_select_sql(start_date, end_date)))
      insert_manager.into(self.arel_table)
      insert_manager.columns << self.arel_table[:facility_group_id]
      insert_manager.columns << self.arel_table[:date]
      insert_manager.columns << self.arel_table[:time_index_id]
      insert_manager.columns << self.arel_table[:value]
      insert_manager.columns << self.arel_table[:created_at]
      insert_manager.columns << self.arel_table[:created_by]
      insert_manager.columns << self.arel_table[:updated_at]
      insert_manager.columns << self.arel_table[:updated_by]
      insert_manager.to_sql + " ON DUPLICATE KEY UPDATE value=value, updated_at=updated_at, updated_by=updated_by"
    end

    def generate_select_sql(start_date, end_date)
      Dlt::UsageFixedDetail
        .joins(usage_fixed_header: :supply_point)
        .where(['date >= ? and date <= ?', start_date, end_date])
        .where.not(facility_group_id: nil)
        .distinct
        .select([
                  :facility_group_id,
                  :date,
                  :time_index_id,
                  Arel.sql("SUM(CASE journal_code WHEN '2' THEN `dlt_usage_fixed_details`.`usage` ELSE `dlt_usage_fixed_details`.`usage_all` END) AS value"),
                  Arel.sql("NOW() as created_at"),
                  Arel.sql("1 as created_by"),
                  Arel.sql("NOW() as updated_at"),
                  Arel.sql("1 as updated_by")
                ])
        .group(:facility_group_id, :date, :time_index_id).to_sql
    end
  end
end
