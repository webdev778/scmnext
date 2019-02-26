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

  class << self
    def import_data(year)
      conn = Faraday::Connection.new(:url => 'http://www.jepx.org') do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Adapter::NetHttp
      end
      response = conn.get('market/excel/spot_' + year.to_s + '.csv')
      csv = CSV.parse(response.body, headers: true)
      (0..csv.length - 1).each do |i|
        area = []
        same_datetime_record = self.find_by(date: csv[i][0], time_index_id: csv[i][1])
        if same_datetime_record
          area_data_id = same_datetime_record.spot_trade_area_data.first.id
          (1..9).each do |j|
            area << {id: (area_data_id + j - 1), area_price: csv[i][j + 5], avoidable_price: csv[i][j + 22]}
          end
          row = {
            sell_bit_amount: csv[i][2],
            buy_bit_amount: csv[i][3],
            execution_amount: csv[i][4],
            system_price: csv[i][5],
            avoidable_cost: csv[i][22],
            spot_avg_per_price: csv[i][16],
            alpha_max_times_spot_avg_per_price: csv[i][17],
            alpha_min_times_spot_avg_per_price: csv[i][18],
            alpha_preliminary_times_spot_avg_per_price: csv[i][19],
            alpha_fixed_times_spot_avg_per_price: csv[i][20],
            spot_trade_area_data_attributes: area
          }
          same_datetime_record.update(row)
        else
          (1..9).each do |j|
            district = District.find_by(code: "0#{j}")
            area << {district_id: district.id, area_price: csv[i][j + 5], avoidable_price: csv[i][j + 22]}
          end
          row = {
            date: csv[i][0],
            time_index_id: csv[i][1],
            sell_bit_amount: csv[i][2],
            buy_bit_amount: csv[i][3],
            execution_amount: csv[i][4],
            system_price: csv[i][5],
            avoidable_cost: csv[i][22],
            spot_avg_per_price: csv[i][16],
            alpha_max_times_spot_avg_per_price: csv[i][17],
            alpha_min_times_spot_avg_per_price: csv[i][18],
            alpha_preliminary_times_spot_avg_per_price: csv[i][19],
            alpha_fixed_times_spot_avg_per_price: csv[i][20],
            spot_trade_area_data_attributes: area
          }
          self.create(row)
        end
      end
    end
  end
end