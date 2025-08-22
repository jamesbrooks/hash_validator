class HashValidator::Validator::LambdaValidator < HashValidator::Validator::Base
  def initialize
    super('_lambda')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
  end

  def should_validate?(rhs)
    if rhs.is_a?(Proc)
      if rhs.arity == 1
        true
      else
        raise HashValidator::Validator::LambdaValidator::InvalidArgumentCount.new("Lambda validator should only accept one argument, supplied lambda accepts #{rhs.arity}.")
      end
    else
      false
    end
  end

  def error_message
    'is not valid'
  end

  def valid?(value, lambda)
    lambda.call(value)
  rescue
    false
  end
end

class HashValidator::Validator::LambdaValidator::InvalidArgumentCount < StandardError
end

HashValidator.add_validator(HashValidator::Validator::LambdaValidator.new)
