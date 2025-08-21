require 'ipaddr'

class HashValidator::Validator::IpValidator < HashValidator::Validator::Base
  def initialize
    super('ip')  # The name of the validator
  end

  def presence_error_message
    'is not a valid IP address'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_ip?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_ip?(value)
    # Use IPAddr to validate both IPv4 and IPv6 addresses
    IPAddr.new(value)
    true
  rescue IPAddr::Error, IPAddr::InvalidAddressError
    false
  end
end

HashValidator.append_validator(HashValidator::Validator::IpValidator.new)