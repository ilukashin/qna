FactoryBot.define do
  sequence :title do |n|
    "Test question #{n}"
  end

  factory :question do
    title
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
