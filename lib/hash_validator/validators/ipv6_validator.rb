# frozen_string_literal: true

require "ipaddr"

class HashValidator::Validator::Ipv6Validator < HashValidator::Validator::Base
  def initialize
    super("ipv6")  # The name of the validator
  end

  def error_message
    "is not a valid IPv6 address"
  end

  def valid?(value)
    return false unless value.is_a?(String)
    # Use IPAddr to validate IPv6 addresses (handles standard and compressed notation)
    addr = IPAddr.new(value)
    addr.ipv6?
  rescue IPAddr::Error, IPAddr::InvalidAddressError
    false
  end
end

HashValidator.add_validator(HashValidator::Validator::Ipv6Validator.new)
