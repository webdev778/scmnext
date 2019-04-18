# == Schema Information
#
# Table name: dlt_usage_fixed_headers
#
#  id                      :bigint(8)        not null, primary key
#  file_id                 :bigint(8)
#  year                    :integer          not null
#  month                   :integer          not null
#  supply_point_number     :string(22)       not null
#  consumer_code           :string(21)
#  consumer_name           :string(80)
#  supply_point_name       :string(70)
#  voltage_class_name      :string(4)
#  journal_code            :integer
#  can_provide             :boolean
#  usage_all               :decimal(10, 4)
#  usage                   :decimal(10, 4)
#  power_factor            :decimal(10, 4)
#  max_power               :decimal(10, 4)
#  next_meter_reading_date :date
#  created_by              :integer
#  updated_by              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class Dlt::UsageFixedHeaderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
