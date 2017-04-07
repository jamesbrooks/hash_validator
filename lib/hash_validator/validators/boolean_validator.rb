class HashValidator::Validator::BooleanValidator < HashValidator::Validator::Base
  def initialize
    super('boolean')  # The name of the validator
  end

  def validate(key, value, _validations, errors)
    unless [TrueClass, FalseClass].include?(value.class)
      errors[key] = presence_error_message
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::BooleanValidator.new)
