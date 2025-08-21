class HashValidator::Validator::DigitsValidator < HashValidator::Validator::Base
  def initialize
    super('digits')  # The name of the validator
  end

  def error_message
    'must contain only digits'
  end

  def valid?(value)
    value.is_a?(String) && /\A\d+\z/.match?(value)
  end
end

HashValidator.append_validator(HashValidator::Validator::DigitsValidator.new)