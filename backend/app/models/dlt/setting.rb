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
