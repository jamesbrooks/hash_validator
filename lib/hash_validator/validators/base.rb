class HashValidator::Validator::Base
  def should_validate?(name)
    raise StandardError.new('should_validate? should not be called directly on BaseValidator')
  end

  def validate(key, value, validations, errors)
    raise StandardError.new('validate should not be called directly on BaseValidator')
  end
end
