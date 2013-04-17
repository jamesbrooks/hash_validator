class HashValidator::Validator::PresenceValidator < HashValidator::Validator::Base
  def name
    'required'
  end

  def presence_error_message
    'is required'
  end

  def should_validate?(rhs)
    rhs == name
  end

  def validate(key, value, validations, errors)
    unless value
      errors[key] = presence_error_message
    end
  end
end


HashValidator.append_validator(HashValidator::Validator::PresenceValidator.new)
