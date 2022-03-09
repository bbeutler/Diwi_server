FactoryBot.define do
  factory :photo do
    image do
      Rack::Test::UploadedFile.new(
        "#{Rails.root}/spec/support/attachments/pink-dress.png", 'image/png'
      )
    end
    look
  end
end
