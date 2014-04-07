module HashValidator::Validations
  class Optional
    attr_reader :validation
    def initialize(validation)
      @validation = validation
    end
  end
end
