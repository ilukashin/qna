FactoryBot.define do
  sequence :body do |n|
    "Test answer #{n}"
  end

  factory :answer do
    body

    trait :invalid do
      body { nil }
    end
  end
end
