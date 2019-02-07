# == Schema Information
#
# Table name: facility_groups
#
#  id                :bigint(8)        not null, primary key
#  name              :string(40)       not null
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

  class_attribute :low_voltage_conversion_map

  class << self
    #
    # 会社、エリア、契約をキーにFacilityGroupのIDを返す変換用ハッシュを返す
    #
    def get_low_voltage_conversion_map
      self.low_voltage_conversion_map ||= select(:id, :company_id, :district_id, :contract_id, :contract_capacity)
      .where(voltage_type_id: 99)
      .distinct
      .map do |facility_group|
        [[facility_group.company_id, facility_group.district_id, facility_group.contract_id, facility_group.contract_capacity], facility_group.id]
      end.to_h
    end
  end
end
