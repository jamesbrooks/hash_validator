class HashValidator::Validator::AlphaValidator < HashValidator::Validator::Base
  def initialize
    super('alpha')  # The name of the validator
  end

  def presence_error_message
    'must contain only letters'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_alpha?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_alpha?(value)
    /\A[a-zA-Z]+\z/.match?(value)
  end
end

HashValidator.append_validator(HashValidator::Validator::AlphaValidator.new)