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
    # the first item in specification is always ":array"
    unless specification[0] == :array
      errors[key] = "Wrong array specification. The #{:array} is expected as first item."
      return
    end

    if specification.size > 2
      errors[key] = "Wrong size of array specification. Allowed is one or two items."
      return
    end

    unless value.is_a?(Array)
      errors[key] = "#{Array} required"
      return
    end

    # second item is optional
    return if specification.size < 2

    array_spec = specification[1]
    return if array_spec.nil? # array specification is optional

    if array_spec.is_a?(Numeric)
      array_spec = { size: array_spec }
    end

    unless array_spec.is_a?(Hash)
      errors[key] = "Second item of array specification must be #{Hash} or #{Numeric}."
      return
    end

    return if array_spec.empty?

    size_spec = array_spec[:size]

    size_spec_present = case size_spec
      when String
        !object.strip.empty?
      when NilClass
        false
      when Numeric
        true
      when Array, Hash
        !object.empty?
      else
        !!object
      end

    if size_spec_present
      unless value.size == size_spec
        errors[key] = "The required size of array is #{size_spec} but is #{value.size}."
        return
      end
    end

    allowed_keys = [:size]
    wrong_keys = array_spec.keys - allowed_keys

    return if wrong_keys.size < 1

    errors[key] = "Not supported specification for array: #{wrong_keys.sort.join(", ")}."
    return
  end
end

HashValidator.append_validator(HashValidator::Validator::ArrayValidator.new)
