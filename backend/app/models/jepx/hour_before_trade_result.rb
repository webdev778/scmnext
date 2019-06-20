# == Schema Information
#
# Table name: jepx_hour_before_trade_results
#
#  id                   :bigint(8)        not null, primary key
#  hour_before_trade_id :bigint(8)
#  is_applied_to_plan   :boolean          default(FALSE), not null
#  unit_price           :integer          default(0), not null
#  qty                  :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Jepx::HourBeforeTradeResult < ApplicationRecord
end
