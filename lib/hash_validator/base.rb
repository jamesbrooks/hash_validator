class HashValidator::Base
  attr_accessor :hash, :validations, :errors


  def initialize(hash, validations)
    self.errors      = {}
    self.hash        = hash
    self.validations = validations

    validate
  end

  def valid?
    errors.empty?
  end

  def self.validate(hash, validations, strict = false)
    @strict = strict
    new(hash, validations)
  end

  def self.strict?
    @strict
  end


private
  def validate
    HashValidator.validator_for(hash).validate(:base, self.hash, self.validations, self.errors)
    self.errors = errors[:base]
  end
end
