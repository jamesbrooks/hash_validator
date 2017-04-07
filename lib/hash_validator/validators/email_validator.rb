class HashValidator::Validator::EmailValidator < HashValidator::Validator::Base
  def initialize
    super('email')  # The name of the validator
  end

  def presence_error_message
    'is not a valid email'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && value.include?("@")
      errors[key] = presence_error_message
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::EmailValidator.new)
