# frozen_string_literal: true

module HashValidatorSpecHelper
  def validate(hash, validations, strict = false)
    HashValidator.validate(hash, validations, strict)
  end
end
