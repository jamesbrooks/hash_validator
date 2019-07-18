class HashValidator::Validator::ClassValidator < HashValidator::Validator::Base
  def initialize
    super('_class')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
  end

  def should_validate?(rhs)
    rhs.is_a?(Class)
  end

  def validate(key, value, klass, errors)
    unless value.is_a?(klass)
      errors[key] = "#{klass} required"
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::ClassValidator.new)
