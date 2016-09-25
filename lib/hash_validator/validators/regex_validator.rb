class HashValidator::Validator::RegexpValidator < HashValidator::Validator::Base
  def initialize
    super('_regex')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
  end

  def should_validate?(rhs)
    rhs.is_a?(Regexp)
  end

  def presence_error_message
    'does not match regular expression'
  end

  def validate(key, value, regexp, errors)
    unless regexp.match(value.to_s)
      errors[key] = presence_error_message
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::RegexpValidator.new)
