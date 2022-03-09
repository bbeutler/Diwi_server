FactoryBot.define do
  factory :tag do
    title { Faker::Name.name }
    consumer
  end

  trait :has_look_tags do
    after :create do |tag|
      look = create(:look, consumer: tag.consumer)
      create :look_tag, tag: tag, look: look
    end
  end
end
