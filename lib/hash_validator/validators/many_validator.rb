module HashValidator
  module Validator
    class ManyValidator < Base
      def initialize
        super('_many')  # The name of the validator, underscored as it won't usually be directly invoked (invoked through use of validator)
      end

      def should_validate?(validation)
        validation.is_a?(Validations::Many)
      end

      def presence_error_message
        "enumerable required"
      end

      def validate(key, value, validations, errors)
        unless value.is_a?(Enumerable)
          errors[key] = presence_error_message
          return
        end

        element_errors = Array.new

        value.each_with_index do |element, i|
          ::HashValidator.validator_for(validations.validation).validate(i, element, validations.validation, element_errors)
        end

        element_errors.each_with_index do |e, i|
          if e.respond_to?(:empty?) && e.empty?
            element_errors[i] = nil
          end
        end

        errors[key] = element_errors unless element_errors.all?(&:nil?)
      end
    end
  end
end

HashValidator.append_validator(HashValidator::Validator::ManyValidator.new)
