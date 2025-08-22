class HashValidator::Validator::AlphanumericValidator < HashValidator::Validator::Base
  def initialize
    super('alphanumeric')  # The name of the validator
  end

  def error_message
    'must contain only letters and numbers'
  end

  def valid?(value)
    value.is_a?(String) && /\A[a-zA-Z0-9]+\z/.match?(value)
  end
end

HashValidator.add_validator(HashValidator::Validator::AlphanumericValidator.new)