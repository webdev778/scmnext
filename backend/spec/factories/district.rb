FactoryBot.define do
  factory :district do
    name {"東京"}
    code {"03"}
    is_partial_included {false}

    factory :district_tokyo do
      name {"東京電力"}
      code {"03"}
      is_partial_included {false}
    end

    factory :district_kansai do
      name {"関西電力"}
      code {"05"}
      is_partial_included {false}
    end
  end

end
