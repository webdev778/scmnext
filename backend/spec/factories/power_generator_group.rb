FactoryBot.define do
  factory :power_generator_group do
    name {"京葉ガス_03_G_01"}
    code {"GC033"}
    contract_number {"065C001"}

    after(:build) do |power_generator_group|
      power_generator_group.power_generators = build_list(:power_generator, 3)
    end
  end
end
