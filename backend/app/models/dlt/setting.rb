# == Schema Information
#
# Table name: dlt_settings
#
#  id          :bigint(8)        not null, primary key
#  company_id  :bigint(8)
#  district_id :bigint(8)
#  state       :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Dlt::Setting < ApplicationRecord
  belongs_to :company
  belongs_to :district
  has_many :files, class_name: "Dlt::File"

  #
  # 託送への接続情報を取得
  #
  def connection
    return @con unless @con.nil?
    district =self.district
    pkcs12 = self.company.company_account_occto.pkcs12_object
    @con = Faraday::Connection.new(
      url: district.dlt_host,
      ssl: {
        client_key: pkcs12.key,
        client_cert: pkcs12.certificate
      }
    )
    @con
  end
end
