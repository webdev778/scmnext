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

class Resource < ApplicationRecord
  belongs_to :bg_member
  has_many :occto_plan_detail_values, class_name: Occto::PlanDetailValue.to_s

  scope :includes_for_index, lambda {
    includes({bg_member: :company})
  }

  def as_json(options = {})
    if options.blank?
      options = {
        methods: [:type],
        include: {bg_member: {methods: :name}}
      }
    end
    super options
  end

  #
  # 当該リソースの指定日及び時間枠におけるレートを取得する
  # @params date [Date] 日付
  # @params time_index [Integer] 時間枠ID
  # @return [Integer] レート
  def rate_at(date, time_index)
    get_rate_at(date, time_index)
  end

  protected

  #
  # レート取得の実装
  # (継承先で必要に応じて実装する)
  # @params date [Date] 日付
  # @params time_index [Integer] 時間枠ID
  # @return [Integer] レート
  def get_rate_at(date, time_index)
    raise "method not impremented."
  end
end
