# == Schema Information
#
# Table name: companies
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)      not null
#  code        :string(255)      not null
#  name_kana   :string(255)
#  postal_code :string(255)
#  pref_no     :integer
#  city        :string(255)
#  address     :string(255)
#  tel         :string(255)
#  fax         :string(255)
#  email       :string(255)
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Company < ApplicationRecord
  has_one :company_account_jepx
  has_one :company_account_occto
  has_many :consumers
end
