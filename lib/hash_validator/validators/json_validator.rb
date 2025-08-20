require 'json'

class HashValidator::Validator::JsonValidator < HashValidator::Validator::Base
  def initialize
    super('json')  # The name of the validator
  end

  def presence_error_message
    'is not valid JSON'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_json?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_json?(value)
    JSON.parse(value)
    true
  rescue JSON::ParserError
    false
  end
end

HashValidator.append_validator(HashValidator::Validator::JsonValidator.new)