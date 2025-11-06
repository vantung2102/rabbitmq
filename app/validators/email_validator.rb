class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.to_s.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)

    record.errors.add attribute, (options[:message] || I18n.t('validation.email_format_validation_message'))
  end
end
