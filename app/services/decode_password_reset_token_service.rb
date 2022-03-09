class DecodePasswordResetTokenService
  attr_reader :expiration, :email

  def initialize(jwt)
    @jwt = jwt
    @expiration = extract_expiration
    @email = extract_email
  end

  private

  attr_writer :expiration, :email

  def extract_expiration
    decoded_token[0]['exp']
  end

  def extract_email
    decoded_token[0]['email']
  end

  def decoded_token
    @decoded_token ||= JWT.decode(@jwt,
                                  Rails.application.secrets[:secret_key_base],
                                  true,
                                  algorithm: 'HS256')
  end
end
