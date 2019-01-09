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

class CompanyAccount < ApplicationRecord
  has_one_attached :pkcs12

  def pkcs12_object
    OpenSSL::PKCS12.new(self.pkcs12.download, self.passphrase)
  end
end
