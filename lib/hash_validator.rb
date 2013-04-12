require 'hash_validator/base'
require 'hash_validator/version'
require 'hash_validator/validators'

module HashValidator
  def self.validate(*args)
    Base.validate(*args)
  end
end
