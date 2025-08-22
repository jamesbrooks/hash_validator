class HashValidator::Validator::AlphaValidator < HashValidator::Validator::Base
  def initialize
    super('alpha')  # The name of the validator
  end

  def error_message
    'must contain only letters'
  end

  def valid?(value)
    value.is_a?(String) && /\A[a-zA-Z]+\z/.match?(value)
  end
end

HashValidator.add_validator(HashValidator::Validator::AlphaValidator.new)