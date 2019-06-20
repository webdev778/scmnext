FactoryBot.define do
  factory :bg_member do
    company

    factory :bg_member_power_optimizer do
      company { create :company_power_optimizer }
    end

    factory :bg_member_energy_optimizer do
      company { create :company_energy_optimizer }
    end
  end
end
