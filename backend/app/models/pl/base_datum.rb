# == Schema Information
#
# Table name: pl_base_data
#
#  id                                :bigint(8)        not null, primary key
#  facility_group_id                 :bigint(8)
#  type                              :string(255)      not null
#  date                              :date             not null
#  time_index_id                     :bigint(8)        not null
#  amount_actual                     :decimal(10, 4)
#  amount_planned                    :decimal(10, 4)
#  amount_loss                       :decimal(10, 4)
#  amount_imbalance                  :decimal(10, 4)
#  power_factor_rate                 :decimal(10, 4)
#  sales_basic_charge                :decimal(10, 4)
#  sales_mater_rate_charge           :decimal(10, 4)
#  sales_fuel_cost_adjustment        :decimal(10, 4)
#  sales_cost_adjustment             :decimal(10, 4)
#  sales_special_discount            :decimal(10, 4)
#  usage_jbu                         :decimal(10, 4)
#  usage_jepx_spot                   :decimal(10, 4)
#  usage_jepx_1hour                  :decimal(10, 4)
#  usage_fit                         :decimal(10, 4)
#  usage_matching                    :decimal(10, 4)
#  supply_jbu_basic_charge           :decimal(10, 4)
#  supply_jbu_fuel_cost_adjustment   :decimal(10, 4)
#  supply_jepx_spot                  :decimal(10, 4)
#  supply_jepx_1hour                 :decimal(10, 4)
#  supply_fit                        :decimal(10, 4)
#  supply_imbalance                  :decimal(10, 4)
#  supply_wheeler_fundamental_charge :decimal(10, 4)
#  supply_wheeler_mater_rate_charge  :decimal(10, 4)
#  created_by                        :integer
#  updated_by                        :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class Pl::BaseDatum < ApplicationRecord
  belongs_to :facility_group

  class << self
    def generate(date)
      BalancingGroup.all.each do |bg|
        bg.bg_members.each do |bg_member|
          puts [bg.name, bg_member.company.name]
          target_cond = PowerUsagePreliminary
            .includes({facility_group: {supply_points: {facility: :discount_for_facilities}, contract: :contract_basic_charges}})
            .where('facility_groups.district_id': bg.district_id, 'facility_groups.company_id': bg_member.company.id, date: date)
          next if target_cond.count == 0 # 対象データが無い場合はスキップ

          plan_matrix_by_time_index_and_resouce_type = Occto::Plan.includes({ plan_by_bg_members: {plan_detail_values: :resource} })
          .find_by(balancing_group_id: bg.id)
          .matrix_by_time_index_and_resouce_type


          fuel_cost_adjustment_map_by_voltage_class = FuelCostAdjustment
          .where(year: date.year, month: date.month, district_id: bg.district_id)
          .map do |fuel_cost_adjustment|
            [fuel_cost_adjustment.voltage_class, fuel_cost_adjustment]
          end.to_h

          total_by_time_index = target_cond.total_by_time_index

          result = target_cond.all.map do |power_usage|
            amount_planned = plan_matrix_by_time_index_and_resouce_type[power_usage.time_index_id]["demand"] * power_usage.value / total_by_time_index[power_usage.time_index_id]
            loss_rate = 0.042
            amount_loss = power_usage.value * loss_rate
            amount_imbalance = amount_planned - (power_usage.value + amount_loss)
            sales_basic_charge = power_usage.facility_group.basic_charge_at(date)
            {
              date: date,
              time_index_id: power_usage.time_index_id,
              amount_actual: power_usage.value,
              amount_planned: amount_planned,
              amount_loss: amount_loss,
              amount_imbalance: amount_imbalance,
              power_factor_rate:  1,
              sales_basic_charge:  0,
              sales_mater_rate_charge:  0,
              sales_fuel_cost_adjustment:  0,
              sales_cost_adjustment:  0,
              sales_special_discount:  0,
              usage_jbu:  0,
              usage_jepx_spot:  0,
              usage_jepx_1hour:  0,
              usage_fit:  0,
              usage_matching:  0,
              supply_jbu_basic_charge:  0,
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
