FactoryBot.define do
  factory :device do
    enabled { true }
    platform { 'apn' }
    device_token { Faker::Crypto.sha1 }
    consumer { create :consumer }

    trait :consumer_ios do
      device_token { Faker::Crypto.sha1 }
      platform { 'apn' }
      consumer { create :consumer }
    end

    trait :consumer_android do
      device_token { Faker::Crypto.sha1 }
      platform { 'fcm' }
      consumer { create :consumer }
    end

    trait :consumer_disabled do
      device_token { Faker::Crypto.sha1 }
      platform { 'apn' }
      enabled { false }
      consumer { create :consumer }
    end
  end
end
