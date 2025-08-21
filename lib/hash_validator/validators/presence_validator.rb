class HashValidator::Validator::PresenceValidator < HashValidator::Validator::Base
  def initialize
    super('required')
  end

  def error_message
    'is required'
  end

  def valid?(value)
    !value.nil?
  end
end

HashValidator.append_validator(HashValidator::Validator::PresenceValidator.new)
