# == Schema Information
#
# Table name: facilities
#
#  id                            :bigint(8)        not null, primary key
#  name(名前)                      :string(255)
#  code(コード)                     :string(255)
#  consumer_id(需要家ID)            :bigint(8)
#  supply_point_number(供給地点特定番号) :string(255)
#  district_id(供給エリアID)          :bigint(8)
#  voltage_type_id(電圧種別ID)       :bigint(8)
#  supply_start_date(供給開始日)      :date
#  supply_end_date(供給終了日)        :date
#  tel(TEL)                      :string(255)
#  fax(FAX)                      :string(255)
#  email(EMAIL)                  :string(255)
#  url(URL)                      :string(255)
#  postral_code(郵便番号)            :string(255)
#  pref_no(都道府県番号)               :integer
#  city(市区町村)                    :string(255)
#  address(住所)                   :string(255)
#  person_in_charge(担当者)         :string(255)
#  person_in_charge_kana(担当者カナ)  :string(255)
#  created_by                    :integer
#  updated_by                    :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class Facility < ApplicationRecord
  belongs_to :district
  belongs_to :consumer
  belongs_to :voltage_type
end
