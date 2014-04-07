module HashValidator::Validations
  class Many
    attr_reader :validation
    def initialize(validation)
      @validation = validation
    end
  end
end
