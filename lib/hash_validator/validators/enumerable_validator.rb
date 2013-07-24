class HashValidator::Validator::EnumerableValidator < HashValidator::Validator::Base
  def initialize
    super('_enumerable')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
  end

  def should_validate?(rhs)
    rhs.is_a?(Enumerable)
  end

  def presence_error_message
    'value from list required'
  end

  def validate(key, value, validations, errors)
    unless validations.include?(value)
      errors[key] = presence_error_message
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::EnumerableValidator.new)
