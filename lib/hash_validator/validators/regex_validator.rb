class HashValidator::Validator::RegexpValidator < HashValidator::Validator::Base
  def initialize
    super('_regex')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
  end

  def should_validate?(rhs)
    rhs.is_a?(Regexp)
  end

  def error_message
    'does not match regular expression'
  end

  def valid?(value, regexp)
    regexp.match(value.to_s)
  end
end

HashValidator.append_validator(HashValidator::Validator::RegexpValidator.new)
