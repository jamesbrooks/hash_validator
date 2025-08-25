class HashValidator::Validator::ArrayValidator < HashValidator::Validator::Base
  def initialize
    super('__array__')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
  end

  def should_validate?(rhs)
    return false unless rhs.is_a?(Array)
    return false unless rhs.size > 0
    return false unless rhs[0] == :array

    return true
  end

  def validate(key, value, specification, errors)
    # Validate specification format
    if specification[0] != :array
      errors[key] = "Wrong array specification. The #{:array} is expected as first item."
    elsif specification.size > 2
      errors[key] = "Wrong size of array specification. Allowed is one or two items."
    elsif !value.is_a?(Array)
      errors[key] = "#{Array} required"
    elsif specification.size >= 2 && !specification[1].nil?
      validate_array_specification(key, value, specification[1], errors)
    end
  end

  private

  def validate_array_specification(key, value, array_spec, errors)
    # Convert numeric specification to hash format
    array_spec = { size: array_spec } if array_spec.is_a?(Numeric)

    unless array_spec.is_a?(Hash)
      errors[key] = "Second item of array specification must be #{Hash} or #{Numeric}."
      return
    end

    return if array_spec.empty?

    validate_size_specification(key, value, array_spec, errors) if errors.empty?
    validate_allowed_keys(key, array_spec, errors) if errors.empty?
  end

  def validate_size_specification(key, value, array_spec, errors)
    size_spec = array_spec[:size]

    size_spec_present = case size_spec
      when String
        !size_spec.strip.empty?
      when NilClass
        false
      when Numeric
        true
      when Array, Hash
        !size_spec.empty?
      else
        !!size_spec
      end

    if size_spec_present && value.size != size_spec
      errors[key] = "The required size of array is #{size_spec} but is #{value.size}."
    end
  end

  def validate_allowed_keys(key, array_spec, errors)
    allowed_keys = [:size]
    wrong_keys = array_spec.keys - allowed_keys

    if wrong_keys.any?
      errors[key] = "Not supported specification for array: #{wrong_keys.sort.join(", ")}."
    end
  end
end

HashValidator.add_validator(HashValidator::Validator::ArrayValidator.new)
