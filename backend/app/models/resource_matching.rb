# == Schema Information
#
# Table name: resources
#
#  id              :bigint(8)        not null, primary key
#  bg_member_id    :bigint(8)
#  type            :string(255)      not null
#  code            :string(255)      not null
#  name            :string(255)      not null
#  contract_number :string(20)
#  max_value       :decimal(14, )    default(0), not null
#  min_value       :decimal(14, )    default(0), not null
#  unit            :decimal(14, )    default(1), not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ResourceMatching < Resource
  has_many :matching_trade_settings, foreign_key: :resource_id

  def get_pre_defined_supply_value(date, time_index)
    setting get_setting(date)
    unless setting
      raise "対応する相対電源の設定情報が見つかりませんでした。"
    end
    setting.supply_value(time_index)
  end

  def get_setting(date)
    matching_trade_setting.find do |setting|
      setting.is_match_date?(date)
    end
  end

  protected

  #
  # 相対電源のレートを取得する
  # @params date [Date] 日付
  # @params time_index [Integer] 時間枠ID
  # @return [Integer] レート
  def get_rate_at(date, time_index)
    raise "method not impremented."
  end
end
