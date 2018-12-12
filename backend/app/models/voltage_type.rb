# == Schema Information
#
# Table name: voltage_types
#
#  id           :bigint(8)        not null, primary key
#  name(名前)     :string(255)
#  created_by   :integer
#  updated_by   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class VoltageType < ApplicationRecord
  has_many :facilities
  has_many :district_loss_rates
end
