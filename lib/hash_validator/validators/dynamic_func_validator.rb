class HashValidator::Validator::DynamicFuncValidator < HashValidator::Validator::Base
  attr_accessor :func, :custom_error_message

  def initialize(name, func, error_message = nil)
    super(name)
    
    unless func.respond_to?(:call)
      raise ArgumentError, "Function must be callable (proc or lambda)"
    end
    
    @func = func
    @custom_error_message = error_message
  end

  def error_message
    @custom_error_message || super
  end

  def valid?(value)
    begin
      !!@func.call(value)
    rescue => e
      false
    end
  end
end