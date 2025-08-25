# frozen_string_literal: true

module HashValidator::Validations
  class Multiple
    attr_reader :validations
    def initialize(validations)
      @validations = validations
    end
  end
end
