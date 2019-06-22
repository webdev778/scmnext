FactoryBot.define do
  factory :resource do
    name {"エネオプBG関西需要"}
    type {"ResourceSelf"}
    code {"LA586"}

    factory :resource_self, class: ResourceSelf.to_s do
      type {"ResourceSelf"}
      code {"LA586"}
    end

    factory :resource_jepx_spot, class: ResourceJepxSpot.to_s do
      type {"ResourceJepxSpot"}
      max_value { 10000 }
      min_value { 0 }
    end

    factory :resource_jepx_one_hour, class: ResourceJepxOneHour.to_s do
      type {"ResourceJepxOneHour"}
      max_value { 10000 }
      min_value { 0 }
    end

    factory :resource_jbu, class: ResourceJbu.to_s do
      type {"ResourceJbu"}
      code {"LA376"}
      after(:build) do |resource_jbu|
        resource_jbu.jbu_contracts = build_list(:jbu_contract, 3)
      end
    end

    factory :resource_fit, class: ResourceFit.to_s do
      type {"ResourceFit"}
      code {"G0633"}
      after(:build) do |resource_fit|
        resource_fit.power_generator_groups = build_list(:power_generator_group, 2)
      end
    end

    factory :resource_matching, class: ResourceMatching.to_s  do
      type {"ResourceMatching"}
      code {"LA456"}
      name {"シナネン_06_L"}
      after(:build) do |resource_matching|
        resource_matching.matching_trade_settings = build_list(:matching_trade_setting, 2)
      end
    end
  end
end
