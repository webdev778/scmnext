# == Schema Information
#
# Table name: facility_groups
#
#  id                :bigint(8)        not null, primary key
#  name              :string(255)      not null
#  company_id        :bigint(8)
#  district_id       :bigint(8)
#  contract_id       :bigint(8)
#  voltage_type_id   :bigint(8)
#  contract_capacity :string(255)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FacilityGroup < ApplicationRecord
  has_many :supply_points
  has_many :facilities, through: :supply_points
  belongs_to :company
  belongs_to :district
  belongs_to :contract

  #
  # 指定された日付の基本料金を求める
  #
  def basic_charge_at(date)
    contract_basic_charge = self.contract.contract_basic_charges.find{|contract_basic_charge| contract_basic_charge.start_date <= date}
    contract_basic_charge.amount
  end
end
