# == Schema Information
#
# Table name: districts
#
#  id                             :bigint(8)        not null, primary key
#  name                           :string(255)
#  code                           :string(255)
#  loss_rate_special_high_voltage :float(24)
#  loss_rate_high_voltage         :float(24)
#  loss_rate_low_voltage          :float(24)
#  dlt_host                       :string(255)
#  dlt_path                       :string(255)
#  created_by                     :integer
#  updated_by                     :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class District < ApplicationRecord
  has_many :jepx_imbalance_betas, class_name: Jepx::ImbalanceBeta.to_s
  has_many :spot_trade_area_data, class_name: Jepx::SpotTradeAreaDatum.to_s
  has_many :wheeler_charges
  has_many :district_loss_rates
  has_many :facilities
end
