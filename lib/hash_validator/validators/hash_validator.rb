# frozen_string_literal: true

class HashValidator::Validator::HashValidator < HashValidator::Validator::Base
  def initialize
    super("hash")
  end

  def should_validate?(rhs)
    rhs.is_a?(Hash) || (defined?(ActionController::Parameters) && rhs.is_a?(ActionController::Parameters))
  end

  def validate(key, value, validations, errors)
    # Convert ActionController::Parameters to Hash if needed
    if !value.is_a?(Hash) && defined?(ActionController::Parameters) && value.is_a?(ActionController::Parameters)
      value = value.to_unsafe_h
    end

    # Validate hash
    unless value.is_a?(Hash)
      errors[key] = error_message
      return
    end

    # Hashes can contain sub-elements, attempt to validator those
    errors = (errors[key] = {})

    validations.each do |v_key, v_value|
      HashValidator.validator_for(v_value).validate(v_key, value[v_key], v_value, errors)
    end

    if HashValidator::Base.strict?
      value.keys.each do |k|
        errors[k] = "key not expected" unless validations[k]
      end
    end

    # Cleanup errors (remove any empty nested errors)
    errors.delete_if { |_, v| v.empty? }
  end
end


HashValidator.add_validator(HashValidator::Validator::HashValidator.new)
