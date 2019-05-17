# == Schema Information
#
# Table name: resources
#
#  id                 :bigint(8)        not null, primary key
#  balancing_group_id :bigint(8)
#  type               :string(255)      not null
#  code               :string(255)      not null
#  name               :string(255)      not null
#  supply_value       :text(65535)
#  created_by         :integer
#  updated_by         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Resource < ApplicationRecord
  belongs_to :balancing_group
  has_many :occto_plan_detail_values, class_name: Occto::PlanDetailValue.to_s

  scope :includes_for_index, lambda {
    includes([:balancing_group])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        methods: [:type],
        include: :balancing_group
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
