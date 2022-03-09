class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A[^@]+@(?:[^@]+\.)+[^@.]+\z/.freeze

  def validate_each(record, attribute, value)
    return if value =~ VALID_EMAIL_REGEX

    record.errors.add(attribute, error_message)
  end

  private

  def error_message
    options.fetch(:messages, :invalid)
  end
end
