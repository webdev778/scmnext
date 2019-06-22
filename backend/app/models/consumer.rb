# == Schema Information
#
# Table name: consumers
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string(255)
#  code                  :string(255)
#  company_id            :bigint(8)
#  tel                   :string(255)
#  fax                   :string(255)
#  email                 :string(255)
#  url                   :string(255)
#  postal_code           :string(255)
#  pref_no               :integer
#  city                  :string(255)
#  address               :string(255)
#  person_in_charge      :string(255)
#  person_in_charge_kana :string(255)
#  password              :string(255)
#  created_by            :integer
#  updated_by            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Consumer < ApplicationRecord
  belongs_to :company
  has_many :facilities

  scope :includes_for_index, lambda {
    includes([:company])
  }

  class << self
    def json_option
      {
        include: [:company]
      }
    end
  end

end
