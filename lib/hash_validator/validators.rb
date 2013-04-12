module HashValidator
  @@validators = []


  def self.append_validator(validator)
    @@validators << validator
  end

  def self.validator_for(rhs)
    @@validators.detect { |v| v.should_validate?(rhs) } || raise(StandardError.new("Could not find valid validator for: #{rhs}"))
  end

  module Validator
  end
end

# Load validators
require 'hash_validator/validators/base'
require 'hash_validator/validators/hash_validator'
require 'hash_validator/validators/simple_type_validator'
