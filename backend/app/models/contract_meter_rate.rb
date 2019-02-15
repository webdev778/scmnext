class ContractMeterRate < ApplicationRecord
  belongs_to :contract
  belongs_to :contract_item
end
