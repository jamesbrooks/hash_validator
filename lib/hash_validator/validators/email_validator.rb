class HashValidator::Validator::EmailValidator < HashValidator::Validator::Base
  def initialize
    super('email')  # The name of the validator
  end

  def error_message
    'is not a valid email'
  end

  def valid?(value)
    value.is_a?(String) && value.include?("@")
  end
end

HashValidator.add_validator(HashValidator::Validator::EmailValidator.new)
