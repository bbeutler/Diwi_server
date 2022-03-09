FactoryBot.define do
  factory :terms_acceptance do
    accepted_at { Time.current }
    remote_ip { Faker::Internet.ip_v4_address }
    consumer
  end
end