# == Schema Information
#
# Table name: jbu_contracts
#
#  id                                      :bigint(8)        not null, primary key
#  district_id                             :bigint(8)
#  company_id                              :bigint(8)
#  start_date                              :date
#  end_date                                :date
#  contract_power                          :integer
#  basic_charge                            :decimal(10, 4)
#  meter_rate_charge_summer_season_daytime :decimal(10, 4)
#  meter_rate_charge_other_season_daytime  :decimal(10, 4)
#  meter_rate_charge_night                 :decimal(10, 4)
#  meter_rate_charge_peak_time             :decimal(10, 4)
#  created_by                              :integer
#  updated_by                              :integer
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#

class JbuContract < ApplicationRecord
  belongs_to :company
  belongs_to :district
end
