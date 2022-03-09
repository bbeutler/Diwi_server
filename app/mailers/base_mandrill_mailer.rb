require 'mandrill'

class BaseMandrillMailer < ActionMailer::Base
  default(
    from: '"DiWi" <services@didiwearit.com>',
    reply_to: 'services@didiwearit.com'
  )

  layout 'mailer'

  private

  def send_mail(email,
                subject,
                body,
                cc_emails = [],
                from_email = '"DiWi" <services@didiwearit.com>')

    mail(from: from_email,
         reply_to: from_email,
         to: email,
         cc: cc_emails,
         subject: subject) do |format|
      format.html { render html: body.html_safe }
    end
  end

  def mandrill_template(template_slug, attributes = {})
    mandrill = Mandrill::API.new(ENV['SMTP_PASSWORD'])

    merge_vars = attributes.merge(default_attributes).map do |key, value|
      { name: key, content: value }
    end

    mandrill.templates.render(template_slug, [], merge_vars)['html']
  end

  def default_attributes
    { 'CLIENT_ORIGIN' => ENV['EMAIL_ORIGIN'] }
  end
end
