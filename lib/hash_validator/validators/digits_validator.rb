class HashValidator::Validator::DigitsValidator < HashValidator::Validator::Base
  def initialize
    super('digits')  # The name of the validator
  end

  def presence_error_message
    'must contain only digits'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_digits?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_digits?(value)
    /\A\d+\z/.match?(value)
  end
end

HashValidator.append_validator(HashValidator::Validator::DigitsValidator.new)