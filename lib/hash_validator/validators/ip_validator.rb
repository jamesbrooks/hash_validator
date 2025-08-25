# frozen_string_literal: true

require "ipaddr"

class HashValidator::Validator::IpValidator < HashValidator::Validator::Base
  def initialize
    super("ip")  # The name of the validator
  end

  def error_message
    "is not a valid IP address"
  end

  def valid?(value)
    return false unless value.is_a?(String)
    # Use IPAddr to validate both IPv4 and IPv6 addresses
    IPAddr.new(value)
    true
  rescue IPAddr::Error, IPAddr::InvalidAddressError
    false
  end
end

HashValidator.add_validator(HashValidator::Validator::IpValidator.new)
