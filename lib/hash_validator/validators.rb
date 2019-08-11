module HashValidator
  @@validators = []


  def self.append_validator(validator)
    unless validator.is_a?(HashValidator::Validator::Base)
      raise StandardError.new('validators need to inherit from HashValidator::Validator::Base')
    end

    if @@validators.detect { |v| v.name == validator.name }
      raise StandardError.new('validators need to have unique names')
    end

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
require 'hash_validator/validators/simple_validator'
require 'hash_validator/validators/class_validator'
require 'hash_validator/validators/hash_validator'
require 'hash_validator/validators/presence_validator'
require 'hash_validator/validators/simple_type_validators'
require 'hash_validator/validators/boolean_validator'
require 'hash_validator/validators/email_validator'
require 'hash_validator/validators/enumerable_validator'
require 'hash_validator/validators/regex_validator'
require 'hash_validator/validators/lambda_validator'
require 'hash_validator/validators/optional_validator'
require 'hash_validator/validators/many_validator'
require 'hash_validator/validators/multiple_validator'
require 'hash_validator/validators/array_validator'