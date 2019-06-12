# == Schema Information
#
# Table name: company_accounts
#
#  id         :bigint(8)        not null, primary key
#  company_id :bigint(8)
#  type       :string(255)      not null
#  login_code :string(64)       not null
#  password   :string(64)       not null
#  passphrase :string(64)
#  comment    :string(255)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CompanyAccountOccto < CompanyAccount
  def execute_occto_api(path, params)
    if pkcs12_object.nil?
      logger.error("#{bg_member.company.name}の広域アカウント情報の証明書を読み込むことができません。")
      return nil
    end
    con = Faraday::Connection.new(
      url: "https://occtonet.occto.or.jp/",
      ssl: {
        client_key: pkcs12_object.key,
        client_cert: pkcs12_object.certificate
      }
    )
    #con.headers['Host'] = 'occtonet.occto.or.jp'
    #con.headers['Content-type'] = 'application/x-www-form-urlencoded'
    auth_params = {'userid'=>login_code, 'password'=>password}
    params = auth_params.merge(params)
    result = con.post(path, params)
end
end
