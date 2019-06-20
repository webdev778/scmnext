# == Schema Information
#
# Table name: power_generators
#
#  id                       :bigint(8)        not null, primary key
#  power_generator_group_id :bigint(8)
#  code                     :string(5)        not null
#  name                     :string(255)      not null
#  contract_number          :string(20)
#  supply_max               :integer
#  created_by               :integer
#  updated_by               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class PowerGenerator < ApplicationRecord
  belongs_to :power_generator_group, inverse_of: :power_generators
end
