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
    def generate_each_bg_member_data(date, bg_member, power_usage_class)
      power_usage_relation = power_usage_class
        .eager_load({facility_group: {supply_points: {facility: :discount_for_facilities}, contract: :contract_basic_charges}})
        .where('facility_groups.district_id': bg_member.balancing_group.district_id, 'facility_groups.company_id': bg_member.company.id, date: date)
      # 対象データが無い場合はスキップ
      return if power_usage_relation.count == 0
      plan_matrix_by_time_index_and_resouce_type = Occto::Plan.matrix_by_time_index_and_resouce_type(bg_member_id: bg_member.id, date: date)
      # ポジション未登録の場合もスキップ
      return if plan_matrix_by_time_index_and_resouce_type.nil?

      fuel_cost_adjustment_map_by_voltage_class = FuelCostAdjustment
        .where(year: date.year, month: date.month, district_id: bg_member.balancing_group.district_id)
        .map do |fuel_cost_adjustment|
          [fuel_cost_adjustment.voltage_class, fuel_cost_adjustment]
        end.to_h

      total_by_time_index = power_usage_relation.total_by_time_index
      import_data = power_usage_relation.all.map do |power_usage|
        usage = ['demand', 'jepx_spot', 'jepx_1hour', 'jbu', 'fit', 'matching', 'self'].reduce({}) do |usage, resource_type_name|
          usage_value = plan_matrix_by_time_index_and_resouce_type[power_usage.time_index_id][resource_type_name]
          usage_value ||= 0
          usage[resource_type_name] = usage_value * power_usage.value / total_by_time_index[power_usage.time_index_id]
          usage
        end
        voltage_type = power_usage.facility_group.voltage_type
        if voltage_type.nil?
          puts "#{power_usage.facility_group.name} : #{power_usage.facility_group.voltage_type_id}"
          fuel_cost_adjustment = fuel_cost_adjustment_map_by_voltage_class['voltage_class_low']
        else
          fuel_cost_adjustment = fuel_cost_adjustment_map_by_voltage_class[power_usage.facility_group.voltage_type.to_voltage_class]
        end
        fuel_cost_unit_price = fuel_cost_adjustment ? fuel_cost_adjustment.unit_price : 0
        loss_rate = 0.042
        amount_loss = power_usage.value * loss_rate
        amount_imbalance = usage['demand'] - (power_usage.value + amount_loss)
        {
          facility_group_id: power_usage.facility_group_id,
          date: date,
          time_index_id: power_usage.time_index_id,
          amount_actual: power_usage.value,
          amount_planned: usage['demand'],
          amount_loss: amount_loss,
          amount_imbalance: amount_imbalance,
          power_factor_rate: 1,
          sales_basic_charge: power_usage.facility_group.contract.basic_charge_at(date),
          sales_mater_rate_charge: power_usage.facility_group.contract.meter_rate_at(date) * power_usage.value,
          sales_fuel_cost_adjustment: fuel_cost_unit_price * power_usage.value,
          sales_cost_adjustment: power_usage.facility_group.sales_cost_adjustment,
          sales_special_discount: power_usage.facility_group.sales_special_discount_rate_at(date),
          usage_jbu: usage['jbu'],
          usage_jepx_spot: usage['jepx_spot'],
          usage_jepx_1hour: usage['jepx_1hour'],
          usage_fit: usage['jepx_fit'],
          usage_matching: usage['matching'],
          supply_jbu_basic_charge: 0,
          supply_jbu_fuel_cost_adjustment:  0,
          supply_jepx_spot:  0,
          supply_jepx_1hour:  0,
          supply_fit:  0,
          supply_imbalance:  0,
          supply_wheeler_fundamental_charge:  0,
          supply_wheeler_mater_rate_charge:  0
        }
      end
      self.import import_data
    end

    def summary(conditions, group_fields)
      select_items = group_fields + summary_columns.map do |col_name|
        "SUM(#{col_name}) AS #{col_name}"
      end
      includes(:facility_group).select(select_items).distinct.group(group_fields).where(conditions)
    end

    private

    def summary_columns
      [
        :amount_actual,
        :amount_planned,
        :amount_loss,
        :amount_imbalance,
        :sales_basic_charge,
        :sales_mater_rate_charge,
        :sales_fuel_cost_adjustment,
        :sales_cost_adjustment,
        :sales_special_discount,
        :usage_jbu,
        :usage_jepx_spot,
        :usage_jepx_1hour,
        :usage_fit,
        :usage_matching,
        :supply_jbu_basic_charge,
        :supply_jbu_fuel_cost_adjustment,
        :supply_jepx_spot,
        :supply_jepx_1hour,
        :supply_fit,
        :supply_imbalance,
        :supply_wheeler_fundamental_charge,
        :supply_wheeler_mater_rate_charge
      ]
    end
  end

  def facility_group_name
    facility_group.name
  end
end
