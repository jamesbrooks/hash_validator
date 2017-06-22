module HashValidator
  module Validator
    class MultipleValidator < Base
      def initialize
        super('_multiple')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
      end

      def should_validate?(validation)
        validation.is_a?(Validations::Multiple)
      end

      def validate(key, value, validations, errors)
        multiple_errors = []

        validations.validations.each do |validation|
          validation_error = {}
          ::HashValidator.validator_for(validation).validate(key, value, validation, validation_error)
          multiple_errors << validation_error[key] if validation_error[key]
        end

        errors[key] = multiple_errors.join(', ') if multiple_errors.any?
      end
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::MultipleValidator.new)
