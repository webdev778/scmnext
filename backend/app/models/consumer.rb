# == Schema Information
#
# Table name: consumers
#
#  id                           :bigint(8)        not null, primary key
#  name(名前)                     :string(255)
#  code(コード)                    :string(255)
#  company_id(PPS ID)           :bigint(8)
#  tel(TEL)                     :string(255)
#  fax(FAX)                     :string(255)
#  email(EMAIL)                 :string(255)
#  url(URL)                     :string(255)
#  postral_code(郵便番号)           :string(255)
#  pref_no(都道府県番号)              :integer
#  city(市区町村)                   :string(255)
#  address(住所)                  :string(255)
#  person_in_charge(担当者)        :string(255)
#  person_in_charge_kana(担当者カナ) :string(255)
#  password(パスワード)              :string(255)
#  created_by                   :integer
#  updated_by                   :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class Consumer < ApplicationRecord
  belongs_to :company
  has_many :facilities
end
