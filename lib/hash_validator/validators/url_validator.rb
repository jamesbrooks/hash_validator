require 'uri'

class HashValidator::Validator::UrlValidator < HashValidator::Validator::Base
  def initialize
    super('url')  # The name of the validator
  end

  def presence_error_message
    'is not a valid URL'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_url?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_url?(value)
    uri = URI.parse(value)
    %w[http https ftp].include?(uri.scheme)
  rescue URI::InvalidURIError
    false
  end
end

HashValidator.append_validator(HashValidator::Validator::UrlValidator.new)