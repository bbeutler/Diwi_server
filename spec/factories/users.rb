FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { 'password' }
    password_confirmation { password }
    association :profile, factory: :consumer

    trait :consumer_user do
      association :profile, factory: :consumer
    end
  end
end
