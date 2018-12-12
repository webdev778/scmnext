# == Schema Information
#
# Table name: companies
#
#  id                :bigint(8)        not null, primary key
#  name(名前)          :string(255)      not null
#  code(コード)         :string(255)      not null
#  name_kana(名前(カナ)) :string(255)
#  postal_code(郵便番号) :string(255)
#  pref_no(都道府県番号)   :integer
#  city(市区町村)        :string(255)
#  address(住所)       :string(255)
#  tel(TEL)          :string(255)
#  fax(FAX)          :string(255)
#  email(EMAIL)      :string(255)
#  created_by        :integer
#  updated_by        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Company < ApplicationRecord
  has_many :consumers
end
