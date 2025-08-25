# frozen_string_literal: true

class HashValidator::Validator::Base
  attr_accessor :name


  def initialize(name)
    self.name = name.to_s

    unless self.name.size > 0
      raise StandardError.new("Validator must be initialized with a valid name (length greater than zero)")
    end
  end

  def should_validate?(name)
    self.name == name.to_s
  end

  def error_message
    "#{self.name} required"
  end

  def validate(key, value, validations, errors)
    # If the subclass implements valid?, use that for simple boolean validation
    if self.class.instance_methods(false).include?(:valid?)
      # Check the arity of the valid? method to determine how many arguments to pass
      valid_result = case method(:valid?).arity
      when 1
        valid?(value)
      when 2
        valid?(value, validations)
      else
        raise StandardError.new("valid? method must accept either 1 argument (value) or 2 arguments (value, validations)")
      end

      unless valid_result
        errors[key] = error_message
      end
    else
      # Otherwise, subclass must override validate
      raise StandardError.new("Validator must implement either valid? or override validate method")
    end
  end

  # Subclasses can optionally implement this for simple boolean validation
  # Return true if valid, false if invalid
  # Either:
  #   def valid?(value)           # For simple validations
  #   def valid?(value, validations)  # When validation context is needed
  # end
end
