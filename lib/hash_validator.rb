module HashValidator
  def self.validate(*args)
    Base.validate(*args)
  end

  def self.optional(validation)
    Validations::Optional.new(validation)
  end

  def self.many(validation)
    Validations::Many.new(validation)
  end
end

require 'hash_validator/base'
require 'hash_validator/version'
require 'hash_validator/validators'
require 'hash_validator/validations'
