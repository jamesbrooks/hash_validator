class HashValidator::Validator::BooleanValidator < HashValidator::Validator::Base
  def initialize
    super('boolean')  # The name of the validator
  end

  def valid?(value)
    [TrueClass, FalseClass].include?(value.class)
  end
end

HashValidator.add_validator(HashValidator::Validator::BooleanValidator.new)
