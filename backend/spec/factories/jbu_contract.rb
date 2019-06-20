FactoryBot.define do
  factory :jbu_contract do
    start_date {"2018-06-01"}
    contract_power {"400"}
    basic_charge { 1800 }
    meter_rate_charge_summer_season_daytime { 10.11 }
    meter_rate_charge_other_season_daytime { 7.87 }
    meter_rate_charge_night { 7.64 }
    meter_rate_charge_peak_time { 10.11 }
    fuel_cost_adjustment_charge { 0.23 }
  end
end
