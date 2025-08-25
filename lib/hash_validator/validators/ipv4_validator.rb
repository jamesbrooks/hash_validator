# frozen_string_literal: true

class HashValidator::Validator::Ipv4Validator < HashValidator::Validator::Base
  def initialize
    super("ipv4")  # The name of the validator
  end

  def error_message
    "is not a valid IPv4 address"
  end

  def valid?(value)
    return false unless value.is_a?(String)
    # IPv4 regex: 4 octets, each 0-255
    ipv4_regex = /\A(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/
    value.match?(ipv4_regex)
  end
end

HashValidator.add_validator(HashValidator::Validator::Ipv4Validator.new)
