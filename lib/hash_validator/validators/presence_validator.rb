class HashValidator::Validator::PresenceValidator < HashValidator::Validator::Base
  def initialize
    super('required')
  end

  def presence_error_message
    'is required'
  end

  def validate(key, value, _validations, errors)
    if value.nil?
      errors[key] = presence_error_message
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::PresenceValidator.new)
