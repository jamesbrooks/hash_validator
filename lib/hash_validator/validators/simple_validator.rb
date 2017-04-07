class HashValidator::Validator::SimpleValidator < HashValidator::Validator::Base
  attr_accessor :lambda


  def initialize(name, lambda)
    # lambda must accept one argument (the value)
    if lambda.arity != 1
      raise StandardError.new("lambda should take only one argument - passed lambda takes #{lambda.arity}")
    end

    super(name)
    self.lambda = lambda
  end

  def validate(key, value, _validations, errors)
    unless lambda.call(value)
      errors[key] = presence_error_message
    end
  end
end
