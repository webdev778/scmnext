class Pl::BaseDatum < ApplicationRecord
  belongs_to :facility_group

  class << self
    def generate(date)
      BalancingGroup.all.each do |bg|
        bg.companies.each do |company|
          target_cond = PowerUsagePreliminary
            .eager_load({facility_group: {supply_points: {facility: :discount_for_facility}}})
            .where('facility_groups.district_id': bg.district_id, 'facility_groups.company_id': company.id, date: date)
          next if target_cond.count == 0

          fuel_cost_adjustment_map_by_voltage_class = FuelCostAdjustment
          .find_by(year: date.year, month: date.month, district_id: bg.district_id)
          .map do |fuel_cost_adjustment|
            [fuel_cost_adjustment.voltage_class, fuel_cost_adjustment]
          end.to_h

          target_cond.total_by_time_index
          target_cond.all.map do |power_usage|
            {
              date: date,
              time_index: power_usage.time_index,
              amount_actual: power_usage.value,
              amount_planned: 0,
              amount_loss:  0,
              amount_imbalance:  0,
              power_factor_rate:  0,
              sales_fundamental_charge:  0,
              sales_mater_rate_charge:  0,
              sales_fuel_cost_adjustment:  0,
              sales_cost_adjustment:  0,
              sales_special_discount:  0,
              usage_jbu:  0,
              usage_jepx_spot:  0,
              usage_jepx_1hour:  0,
              usage_fit:  0,
              usage_matching:  0,
              supply_jbu_fundamental_charge:  0,
              supply_jbu_fuel_cost_adjustment:  0,
              supply_jepx_spot:  0,
              supply_jepx_1hour:  0,
              supply_fit:  0,
              supply_imbalance:  0,
              supply_wheeler_fundamental_charge:  0,
              supply_wheeler_mater_rate_charge:  0
            }
          end
          binding.pry if result.length > 0
        end
      end
    end
  end
end
