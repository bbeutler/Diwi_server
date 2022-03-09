module AuthHelper
  def token_for(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  def auth_headers_for(user)
    "Bearer #{token_for(user)}"
  end

  def non_auth_headers
    'Bearer '
  end

  def base_64_encoded_image
    File.open("#{Rails.root}/spec/support/attachments/base64-encoded-pink-dress.txt", 'rb').read
  end

  def uploaded_image
    Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/pink-dress.png", 'image/png')
  end
end
