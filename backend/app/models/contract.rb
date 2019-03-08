# == Schema Information
#
# Table name: contracts
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string(255)      not null
#  name_for_invoice       :string(255)      not null
#  voltage_type_id        :bigint(8)
#  contract_item_group_id :bigint(8)
#  start_date             :date
#  end_date               :date
#  created_by             :integer
#  updated_by             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Contract < ApplicationRecord
  has_many :contract_basic_charges, -> { order(start_date: :desc) }
  has_many :contract_meter_rates
  belongs_to :voltage_type
  belongs_to :contract_item_group

  scope :includes_for_index, lambda {
    includes([:voltage_type, :contract_item_group])
  }

  def as_json(options = {})
    if options.blank?
      options = {
        include: [:voltage_type, :contract_item_group]
      }
    end
    super options
  end

  #
  # 指定された日付の基本料金を求める
  #
  def basic_charge_at(date)
    contract_basic_charge = contract_basic_charges
                            .find do |contract_basic_charge|
      contract_basic_charge.start_date <= date
    end
    contract_basic_charge.amount
  end

  #
  # 指定された日付の従量料金を求める
  #
  def meter_rate_at(date)
    return 0 if contract_item.nil?

    contract_meter_rate = contract_meter_rates.find do |contract_meter_rate|
      (
        (contract_meter_rate.contract_item_id == contract_item.id) &&
        (contract_meter_rate.start_date <= date) &&
        (contract_meter_rate.end_date.nil? || (contract_meter_rate.end_date >= date))
      )
    end
    contract_meter_rate ? contract_meter_rate.rate : 0
  end

  def contract_item
    return nil if contract_item_group.nil?

    @contract_item ||= contract_item_group.contract_item_orders
                                          .find do |_contract_item_orders|
      true
    end.contract_item
  end
end
