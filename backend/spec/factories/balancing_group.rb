FactoryBot.define do
  factory :balancing_group do
    code {"LB888"}
    name {"パワオプ東京BG"}
    district

    factory :balancing_group_tokyo do
      code {"LB888"}
      name {"パワオプ東京BG"}
      district { create :district_tokyo }

      after(:create) do |balancing_group|
        balancing_group.bg_members << build(:bg_member_power_optimizer )
        balancing_group.bg_members << build(:bg_member_energy_optimizer )
        balancing_group.save
      end
    end

  end

end
