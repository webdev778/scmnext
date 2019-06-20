FactoryBot.define do
  factory :power_generator_group do
    name {"京葉ガス_03_G_01"}
    code {"GC033"}
    contract_number {"065C001"}

    after(:build) do |power_generator_group|
      power_generator_group.power_generators.build attributes_for(:power_generator, code: "302BP", name: "那須塩原三区ＰＶ", contract_number: "00000002", supply_max: 909)
      power_generator_group.power_generators.build attributes_for(:power_generator, code: "303CU", name: "高萩ビーチＰＶ", contract_number: "00000003", supply_max: 1842)
      power_generator_group.power_generators.build attributes_for(:power_generator, code: "30486", name: "銚子ＰＶ", contract_number: "00000007", supply_max: 1990)
    end
  end
end
