# == Schema Information
#
# Table name: resources
#
#  id              :bigint(8)        not null, primary key
#  bg_member_id    :bigint(8)
#  type            :string(255)      not null
#  code            :string(255)      not null
#  name            :string(255)      not null
#  contract_number :string(20)
#  max_value       :decimal(14, )    default(0), not null
#  min_value       :decimal(14, )    default(0), not null
#  unit            :decimal(14, )    default(1), not null
#  created_by      :integer
#  updated_by      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ResourceJbu < Resource
  has_many :jbu_contracts, foreign_key: :resource_id, inverse_of: :resource
  accepts_nested_attributes_for :jbu_contracts

  def as_json(options = {})
    if options.blank?
      options = {
        methods: [:type],
        include: [:jbu_contracts]
      }
    end
    super options
  end

  private
  #
  # 規定値をセットする
  #
  def set_values
    self.name = "常時バックアップ(#{bg_member.balancing_group.district.name})"
    self.unit = 1
  end
end
