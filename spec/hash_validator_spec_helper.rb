module HashValidatorSpecHelper
  def validate(hash, validations)
    HashValidator.validate(hash, validations)
  end
end
