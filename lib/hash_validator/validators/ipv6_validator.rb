require 'ipaddr'

class HashValidator::Validator::Ipv6Validator < HashValidator::Validator::Base
  def initialize
    super('ipv6')  # The name of the validator
  end

  def presence_error_message
    'is not a valid IPv6 address'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_ipv6?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_ipv6?(value)
    # Use IPAddr to validate IPv6 addresses (handles standard and compressed notation)
    addr = IPAddr.new(value)
    addr.ipv6?
  rescue IPAddr::Error, IPAddr::InvalidAddressError
    false
  end
end

HashValidator.append_validator(HashValidator::Validator::Ipv6Validator.new)