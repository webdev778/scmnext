# == Schema Information
#
# Table name: districts
#
#  id                                        :bigint(8)        not null, primary key
#  name(名前)                                  :string(255)
#  code(コード)                                 :string(255)
#  loss_rate_special_high_voltage(損失率(特別高圧)) :float(24)
#  loss_rate_high_voltage(損失率(高圧))           :float(24)
#  loss_rate_low_voltage(損失率(低圧))            :float(24)
#  created_by                                :integer
#  updated_by                                :integer
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#

class District < ApplicationRecord
  has_many :district_loss_rates
  has_many :facilities
end
