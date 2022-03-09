FactoryBot.define do
  factory :look do
    title { Faker::Lorem.sentence }
    dates_worn { [Faker::Date.between(5.days.ago, Date.today), Faker::Date.between(5.days.ago, Date.today)] }
    consumer
  end

  trait :with_note do
    note { Faker::Lorem.sentence }
  end

  trait :with_location do
    location { Faker::Lorem.sentence }
  end

  trait :has_tags do
    after :create do |look|
      tag = create(:tag, consumer: look.consumer)
      create :look_tag, tag: tag, look: look
    end
  end

  trait :has_photos do
    after :create do |look|
      create_list(:photo, 2, look: look)
    end
  end
end
