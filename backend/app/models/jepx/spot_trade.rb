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
end
