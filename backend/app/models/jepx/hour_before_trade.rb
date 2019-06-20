# == Schema Information
#
# Table name: jepx_hour_before_trades
#
#  id            :bigint(8)        not null, primary key
#  resource_id   :bigint(8)
#  date          :date
#  time_index_id :bigint(8)
#  trade_type    :integer          not null
#  unit_price    :integer          default(0), not null
#  qty           :integer          default(0), not null
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Jepx::HourBeforeTrade < ApplicationRecord
end
