require 'json'

class HashValidator::Validator::JsonValidator < HashValidator::Validator::Base
  def initialize
    super('json')  # The name of the validator
  end

  def error_message
    'is not valid JSON'
  end

  def valid?(value)
    return false unless value.is_a?(String)
    JSON.parse(value)
    true
  rescue JSON::ParserError
    false
  end
end

HashValidator.append_validator(HashValidator::Validator::JsonValidator.new)