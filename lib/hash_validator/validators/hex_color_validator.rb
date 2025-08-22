class HashValidator::Validator::HexColorValidator < HashValidator::Validator::Base
  def initialize
    super('hex_color')  # The name of the validator
  end

  def error_message
    'is not a valid hex color'
  end

  def valid?(value)
    value.is_a?(String) && /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/.match?(value)
  end
end

HashValidator.add_validator(HashValidator::Validator::HexColorValidator.new)