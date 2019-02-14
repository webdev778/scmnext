# == Schema Information
#
# Table name: contract_items
#
#  id                :bigint(8)        not null, primary key
#  name              :string(255)      not null
#  voltage_type_id   :bigint(8)
#  calcuration_order :integer
#  enabled           :boolean
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ContractItem < ApplicationRecord
  has_many :contract_item_orders
  has_many :contract_item_groups, through: :contract_item_orders
  belongs_to :voltage_type
end
