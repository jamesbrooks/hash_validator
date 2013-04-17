class HashValidator::Validator::Base
  attr_accessor :name


  def initialize(name)
    unless name.is_a?(String) && name.size > 0
      raise StandardError.new('Validator must be initialized with a valid name (string with length greater than zero)')
    end

    self.name = name
  end

  def should_validate?(name)
    self.name == name
  end

  def presence_error_message
    "#{self.name} required"
  end

  def validate(key, value, validations, errors)
    raise StandardError.new('validate should not be called directly on BaseValidator')
  end
end
