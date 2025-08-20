class HashValidator::Validator::AlphanumericValidator < HashValidator::Validator::Base
  def initialize
    super('alphanumeric')  # The name of the validator
  end

  def presence_error_message
    'must contain only letters and numbers'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_alphanumeric?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_alphanumeric?(value)
    /\A[a-zA-Z0-9]+\z/.match?(value)
  end
end

HashValidator.append_validator(HashValidator::Validator::AlphanumericValidator.new)