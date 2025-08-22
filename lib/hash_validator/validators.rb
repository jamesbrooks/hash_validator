module HashValidator
  @@validators = []


  def self.remove_validator(name)
    name = name.to_s
    @@validators.reject! { |v| v.name == name }
  end

  def self.add_validator(*args)
    validator = case args.length
    when 1
      # Instance-based validator (existing behavior)
      validator_instance = args[0]
      unless validator_instance.is_a?(HashValidator::Validator::Base)
        raise StandardError.new('validators need to inherit from HashValidator::Validator::Base')
      end
      validator_instance
    when 2
      # Dynamic validator with options
      name = args[0]
      options = args[1]
      
      if options.is_a?(Hash)
        if options[:pattern]
          # Pattern-based validator
          HashValidator::Validator::DynamicPatternValidator.new(name, options[:pattern], options[:error_message])
        elsif options[:func]
          # Function-based validator  
          HashValidator::Validator::DynamicFuncValidator.new(name, options[:func], options[:error_message])
        else
          raise ArgumentError, 'Options hash must contain either :pattern or :func key'
        end
      else
        raise ArgumentError, 'Second argument must be an options hash with :pattern or :func key'
      end
    else
      raise ArgumentError, 'add_validator expects 1 argument (validator instance) or 2 arguments (name, options)'
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
require 'hash_validator/validators/dynamic_pattern_validator'
require 'hash_validator/validators/dynamic_func_validator'
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
require 'hash_validator/validators/url_validator'
require 'hash_validator/validators/json_validator'
require 'hash_validator/validators/hex_color_validator'
require 'hash_validator/validators/alphanumeric_validator'
require 'hash_validator/validators/alpha_validator'
require 'hash_validator/validators/digits_validator'
require 'hash_validator/validators/ipv4_validator'
require 'hash_validator/validators/ipv6_validator'
require 'hash_validator/validators/ip_validator'