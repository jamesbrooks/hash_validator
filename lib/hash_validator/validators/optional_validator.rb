module HashValidator
  module Validator
    class OptionalValidator < Base
      def initialize
        super('_optional')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
      end

      def should_validate?(validation)
        validation.is_a?(Validations::Optional)
      end

      def validate(key, value, validations, errors)
        unless value.nil?
          ::HashValidator.validator_for(validations.validation).validate(key, value, validations.validation, errors)
          errors.delete(key) if errors[key].respond_to?(:empty?) && errors[key].empty?
        end
      end
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::OptionalValidator.new)
