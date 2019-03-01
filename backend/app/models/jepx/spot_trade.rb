# == Schema Information
#
# Table name: jepx_spot_trades
#
#  id                                         :bigint(8)        not null, primary key
#  date                                       :date             not null
#  time_index_id                              :bigint(8)        not null
#  sell_bit_amount                            :decimal(14, )
#  buy_bit_amount                             :decimal(14, )
#  execution_amount                           :decimal(14, )
#  system_price                               :decimal(5, 2)
#  avoidable_cost                             :decimal(5, 2)
#  spot_avg_per_price                         :decimal(5, 2)
#  alpha_max_times_spot_avg_per_price         :decimal(5, 2)
#  alpha_min_times_spot_avg_per_price         :decimal(5, 2)
#  alpha_preliminary_times_spot_avg_per_price :decimal(5, 2)
#  alpha_fixed_times_spot_avg_per_price       :decimal(5, 2)
#  created_by                                 :integer
#  updated_by                                 :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#

class Jepx::SpotTrade < ApplicationRecord
  has_many :spot_trade_area_data

  accepts_nested_attributes_for :spot_trade_area_data

  require 'csv'

  COL_DATE = 0
  COL_TIME_INDEX_ID = 1
  COL_SELL_BIT_AMOUNT = 2
  COL_BUY_BIT_AMOUNT = 3
  COL_EXECUTION_AMOUNT = 4
  COL_SYSTEM_PRICE = 5
  COL_AVOIDABLE_COST = 22
  COL_SPOT_AVG_PRE_PRICE = 16
  COL_ALPHA_MAX_TIMES_SPOT_AVG_PER_PRICE = 17
  COL_ALPHA_MIN_TIMES_SPOT_AVG_PER_PRICE = 18
  COL_ALPHA_PRELIMINARY_TIMES_SPOT_AVG_PER_PRICE = 19
  COL_ALPHA_FIXED_TIMES_SPOT_AVG_PER_PRICE = 20

  class << self
    def get_row_data(line, area)
      row = {
        date: line[COL_DATE],
        time_index_id: line[COL_TIME_INDEX_ID],
        sell_bit_amount: line[COL_SELL_BIT_AMOUNT],
        buy_bit_amount: line[COL_BUY_BIT_AMOUNT],
        execution_amount: line[COL_EXECUTION_AMOUNT],
        system_price: line[COL_SYSTEM_PRICE],
        avoidable_cost: line[COL_AVOIDABLE_COST],
        spot_avg_per_price: line[COL_SPOT_AVG_PRE_PRICE],
        alpha_max_times_spot_avg_per_price: line[COL_ALPHA_MAX_TIMES_SPOT_AVG_PER_PRICE],
        alpha_min_times_spot_avg_per_price: line[COL_ALPHA_MIN_TIMES_SPOT_AVG_PER_PRICE],
        alpha_preliminary_times_spot_avg_per_price: line[COL_ALPHA_PRELIMINARY_TIMES_SPOT_AVG_PER_PRICE],
        alpha_fixed_times_spot_avg_per_price: line[COL_ALPHA_FIXED_TIMES_SPOT_AVG_PER_PRICE],
        spot_trade_area_data_attributes: area
      }
      return row
    end

    def import_data(year)
      conn = Faraday::Connection.new(url: 'http://www.jepx.org') do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Adapter::NetHttp
      end
      response = conn.get('market/excel/spot_' + year.to_s + '.csv')
      csv = CSV.parse(response.body, headers: true)
      district_hash = District.get_hashed_data
      csv.each do |line|
        area = []
        same_datetime_record = find_by(date: line[COL_DATE], time_index_id: line[COL_TIME_INDEX_ID])
        if same_datetime_record
          area_data_id = same_datetime_record.spot_trade_area_data.pluck(:id)
          (1..9).each do |j|
            area << { id: (area_data_id[j - 1]), area_price: line[j + COL_SYSTEM_PRICE], avoidable_price: line[j + COL_AVOIDABLE_COST] }
          end
          row = self.get_row_data(line, area)
          same_datetime_record.update(row)
        else
          (1..9).each do |j|
            area << { district_id: district_hash["0#{j}"], area_price: line[j + COL_SYSTEM_PRICE], avoidable_price: line[j + COL_AVOIDABLE_COST] }
          end
          row = self.get_row_data(line, area)
          create(row)
        end
      end
    end
  end
end
