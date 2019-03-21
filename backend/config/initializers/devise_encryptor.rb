module Devise
  module Encryptable
    module Encryptors
      class SimpleSha1 < Base
        def self.digest(password, stretches, salt, pepper)
          Digest::SHA1.hexdigest(password)
        end
      end
    end
  end
end
