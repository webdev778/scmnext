# == Schema Information
#
# Table name: contract_item_groups
#
#  id              :bigint(8)        not null, primary key
#  name            :string(255)      not null
#  voltage_type_id :bigint(8)
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ContractItemGroup < ApplicationRecord
  has_many :contract_item_orders, -> { order(sort_order: :asc) }
  has_many :contract_items, through: :contract_item_orders
  has_many :available_contract_items, -> { where(enabled: true) }, source: :contract_item, through: :contract_item_orders
  has_many :contracts

  belongs_to :voltage_type

  scope :includes_for_index, lambda {
    includes([:voltage_type])
  }

  class << self
    def json_option
      {
        include: :voltage_type
      }
    end
  end
end
