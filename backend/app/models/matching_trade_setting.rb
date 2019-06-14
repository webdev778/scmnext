# == Schema Information
#
# Table name: matching_trade_settings
#
#  id                  :bigint(8)        not null, primary key
#  resource_id         :bigint(8)
#  year_pattern        :string(255)      default("*"), not null
#  month_pattern       :string(255)      default("*"), not null
#  day_pattern         :string(255)      default("*"), not null
#  day_of_week_pattern :string(255)      default("*"), not null
#  time_index_1        :integer          default(0), not null
#  time_index_2        :integer          default(0), not null
#  time_index_3        :integer          default(0), not null
#  time_index_4        :integer          default(0), not null
#  time_index_5        :integer          default(0), not null
#  time_index_6        :integer          default(0), not null
#  time_index_7        :integer          default(0), not null
#  time_index_8        :integer          default(0), not null
#  time_index_9        :integer          default(0), not null
#  time_index_10       :integer          default(0), not null
#  time_index_11       :integer          default(0), not null
#  time_index_12       :integer          default(0), not null
#  time_index_13       :integer          default(0), not null
#  time_index_14       :integer          default(0), not null
#  time_index_15       :integer          default(0), not null
#  time_index_16       :integer          default(0), not null
#  time_index_17       :integer          default(0), not null
#  time_index_18       :integer          default(0), not null
#  time_index_19       :integer          default(0), not null
#  time_index_20       :integer          default(0), not null
#  time_index_21       :integer          default(0), not null
#  time_index_22       :integer          default(0), not null
#  time_index_23       :integer          default(0), not null
#  time_index_24       :integer          default(0), not null
#  time_index_25       :integer          default(0), not null
#  time_index_26       :integer          default(0), not null
#  time_index_27       :integer          default(0), not null
#  time_index_28       :integer          default(0), not null
#  time_index_29       :integer          default(0), not null
#  time_index_30       :integer          default(0), not null
#  time_index_31       :integer          default(0), not null
#  time_index_32       :integer          default(0), not null
#  time_index_33       :integer          default(0), not null
#  time_index_34       :integer          default(0), not null
#  time_index_35       :integer          default(0), not null
#  time_index_36       :integer          default(0), not null
#  time_index_37       :integer          default(0), not null
#  time_index_38       :integer          default(0), not null
#  time_index_39       :integer          default(0), not null
#  time_index_40       :integer          default(0), not null
#  time_index_41       :integer          default(0), not null
#  time_index_42       :integer          default(0), not null
#  time_index_43       :integer          default(0), not null
#  time_index_44       :integer          default(0), not null
#  time_index_45       :integer          default(0), not null
#  time_index_46       :integer          default(0), not null
#  time_index_47       :integer          default(0), not null
#  time_index_48       :integer          default(0), not null
#  created_by          :integer
#  updated_by          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class MatchingTradeSetting < ApplicationRecord

  def supply_value(time_index)
    if !time_index.is_a?(Integer) or time_index < 1 or time_index > 48
      raise "時間枠は1～48までの数字を指定してください。"
    end
    send("time_index_#{time_index}")
  end

  def is_match_date?(date)
    is_match_year?(date.year) and is_match_month?(date.month) and is_match_day?(date.day) and is_match_day_of_week?(date.wday)
  end

  private
  def is_match_year?(year)
    is_match_pattern?(year, year_pattern)
  end

  def is_match_month?(month)
    is_match_pattern?(month, month_pattern)
  end

  def is_match_day?(day)
    is_match_pattern?(day, day_pattern)
  end

  def is_match_day_of_week?(day_of_week)
    is_match_pattern?(day_of_week, day_of_week_pattern)
  end

  def is_match_pattern?(target, pattern)
    # @todo カンマ区切りや範囲にも対応のこと
    if pattern == '*'
      return true
    else
      pattern.to_i == target.to_i
    end
  end
end
