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

class ResourceJepxOneHour < Resource
  protected

  #
  # JEPX1時間前調達のレートを取得する
  # @params date [Date] 日付
  # @params time_index [Integer] 時間枠ID
  # @return [Integer] レート
  def get_rate_at(date, time_index)
    raise "method not impremented."
  end
end
