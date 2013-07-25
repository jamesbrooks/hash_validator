class HashValidator::Validator::HashValidator < HashValidator::Validator::Base
  def initialize
    super('hash')
  end

  def should_validate?(rhs)
    rhs.is_a?(Hash)
  end

  def validate(key, value, validations, errors)
    # Validate hash
    unless value.is_a?(Hash)
      errors[key] = presence_error_message
      return
    end

    # Hashes can contain sub-elements, attempt to validator those
    errors = (errors[key] = {})

    validations.each do |v_key, v_value|
      HashValidator.validator_for(v_value).validate(v_key, value[v_key], v_value, errors)
    end

    # Cleanup errors (remove any empty nested errors)
    errors.delete_if { |k,v| v.empty? }
  end
end


HashValidator.append_validator(HashValidator::Validator::HashValidator.new)
