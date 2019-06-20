FactoryBot.define do
  factory :resource do
    name {"エネオプBG関西需要"}
    type {"ResourceSelf"}
    code {"LA586"}

    factory :resource_self do
      type {"ResourceSelf"}
      code {"LA586"}
    end

    factory :resource_jepx_spot do
      type {"ResourceJepxSpot"}
      max_value { 10000 }
      min_value { 0 }
    end

    factory :resource_jepx_one_hour do
      type {"ResourceJepxOneHour"}
      max_value { 10000 }
      min_value { 0 }
    end

    factory :resource_jbu, class: ResourceJbu.to_s do
      type {"ResourceJbu"}
      code {"LA376"}
      after(:build) do |resource_jbu|
        resource_jbu.jbu_contracts.build attributes_for(:jbu_contract)
        resource_jbu.jbu_contracts.build attributes_for(:jbu_contract, start_date: '2017-04-24')
        resource_jbu.jbu_contracts.build attributes_for(:jbu_contract, start_date: '2018-07-24')
      end
    end

    factory :resource_fit, class: ResourceFit.to_s do
      type {"ResourceFit"}
      code {"G0633"}
      after(:build) do |resource_fit|
        resource_fit.power_generator_groups.build attributes_for(:power_generator_group, name: "京葉発電BG1")
        resource_fit.power_generator_groups.build attributes_for(:power_generator_group, name: "京葉発電BG2")
      end
    end

    factory :resource_matching, class: ResourceMatching.to_s  do
      type {"ResourceMatching"}
      code {"LA456"}
      name {"シナネン_06_L"}
      after(:build) do |resource_matching|
        resource_matching.matching_trade_settings.build attributes_for(:matching_trade_setting, month_pattern: 7)
        resource_matching.matching_trade_settings.build attributes_for(:matching_trade_setting)
      end
    end
  end
end
