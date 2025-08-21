require 'uri'

class HashValidator::Validator::UrlValidator < HashValidator::Validator::Base
  def initialize
    super('url')  # The name of the validator
  end

  def error_message
    'is not a valid URL'
  end

  def valid?(value)
    return false unless value.is_a?(String)
    uri = URI.parse(value)
    %w[http https ftp].include?(uri.scheme)
  rescue URI::InvalidURIError
    false
  end
end

HashValidator.append_validator(HashValidator::Validator::UrlValidator.new)