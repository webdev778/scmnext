class CompanyAccount < ApplicationRecord
  has_one_attached :pkcs12

  def pkcs12_object
    OpenSSL::PKCS12.new(self.pkcs12.download, self.passphrase)
  end
end
