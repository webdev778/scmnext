# == Schema Information
#
# Table name: jepx_spot_trade_area_data
#
#  id              :bigint(8)        not null, primary key
#  spot_trade_id   :bigint(8)
#  district_id     :bigint(8)
#  area_price      :decimal(5, 2)
#  avoidable_price :decimal(5, 2)
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Jepx::SpotTradeAreaDatum < ApplicationRecord
  belongs_to :district
  belongs_to :spot_trade
end
