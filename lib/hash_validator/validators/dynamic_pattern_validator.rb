class HashValidator::Validator::DynamicPatternValidator < HashValidator::Validator::Base
  attr_accessor :pattern, :custom_error_message

  def initialize(name, pattern, error_message = nil)
    super(name)
    
    unless pattern.is_a?(Regexp)
      raise ArgumentError, "Pattern must be a regular expression"
    end
    
    @pattern = pattern
    @custom_error_message = error_message
  end

  def error_message
    @custom_error_message || super
  end

  def valid?(value)
    return false unless value.respond_to?(:to_s)
    @pattern.match?(value.to_s)
  end
end