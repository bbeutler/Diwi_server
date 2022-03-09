class ConsumerMailer < BaseMandrillMailer
  default from: 'services@didiwearit.com'
  layout 'mailer'

  def password_reset(user_id, jwt)
    user = User.find(user_id)
    token = jwt
    profile = user.profile
    email = user.email
    merge_vars = {
      'RESET_LINK' => "#{ENV["EMAIL_ORIGIN"]}/passwords/#{user.id}/edit?token=#{token}",
      'USER_NAME' => profile.first_name.capitalize
    }

    body = mandrill_template('password-reset', merge_vars)
    send_mail(email, 'Your Password Reset is Here', body)
  end
end
