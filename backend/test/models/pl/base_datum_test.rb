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
#  sales_meter_rate_charge           :decimal(10, 4)
#  sales_fuel_cost_adjustment        :decimal(10, 4)
#  sales_cost_adjustment             :decimal(10, 4)
#  sales_special_discount            :decimal(10, 4)
#  usage_jbu                         :decimal(10, 4)
#  usage_jepx_spot                   :decimal(10, 4)
#  usage_jepx_1hour                  :decimal(10, 4)
#  usage_fit                         :decimal(10, 4)
#  usage_matching                    :decimal(10, 4)
#  supply_jbu_basic_charge           :decimal(10, 4)
#  supply_jbu_meter_rate_charge      :decimal(10, 4)
#  supply_jbu_fuel_cost_adjustment   :decimal(10, 4)
#  supply_jepx_spot                  :decimal(10, 4)
#  supply_jepx_1hour                 :decimal(10, 4)
#  supply_fit                        :decimal(10, 4)
#  supply_matching                   :decimal(10, 4)
#  supply_imbalance                  :decimal(10, 4)
#  supply_wheeler_fundamental_charge :decimal(10, 4)
#  supply_wheeler_meter_rate_charge  :decimal(10, 4)
#  created_by                        :integer
#  updated_by                        :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

require 'test_helper'

class Pl::BaseDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
