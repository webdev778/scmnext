FactoryBot.define do
  factory :company do
    name {"パワーオプティマイザー"}
    code {"4444"}
    name_kana {"パワーオプティマイザー"}
    postal_code {"100-9999"}
    pref_no {"30"}
    city {"千代田区"}
    address {"千代田1-1-1"}
    tel {"03-3333-4444"}
    fax {"03-4444-5555"}
    email {""}

    factory :company_power_optimizer do
      name {"パワーオプティマイザー"}
      code {"4444"}
      name_kana {"パワーオプティマイザー"}
    end

    factory :company_energy_optimizer do
      name {"エネルギーオプティマイザー"}
      code {"4444"}
      name_kana {"エネルギーオプティマイザー"}
    end
  end
end
