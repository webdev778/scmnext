# == Schema Information
#
# Table name: power_generator_groups
#
#  id              :bigint(8)        not null, primary key
#  resource_id     :bigint(8)
#  name            :string(255)
#  code            :string(5)
#  contract_number :string(20)
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PowerGeneratorGroup < ApplicationRecord
  has_many :power_generators
  belongs_to :resource
end
