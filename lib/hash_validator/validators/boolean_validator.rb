class HashValidator::Validator::BooleanValidator < HashValidator::Validator::Base
  def initialize
    super('boolean')  # The name of the validator
  end

  def valid?(value)
    [TrueClass, FalseClass].include?(value.class)
  end
end

HashValidator.append_validator(HashValidator::Validator::BooleanValidator.new)
