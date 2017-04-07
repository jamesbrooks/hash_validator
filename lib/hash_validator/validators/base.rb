class HashValidator::Validator::Base
  attr_accessor :name


  def initialize(name)
    self.name = name.to_s

    unless self.name.size > 0
      raise StandardError.new('Validator must be initialized with a valid name (length greater than zero)')
    end
  end

  def should_validate?(name)
    self.name == name.to_s
  end

  def presence_error_message
    "#{self.name} required"
  end

  def validate(*)
    raise StandardError.new('validate should not be called directly on BaseValidator')
  end
end
