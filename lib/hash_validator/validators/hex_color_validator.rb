class HashValidator::Validator::HexColorValidator < HashValidator::Validator::Base
  def initialize
    super('hex_color')  # The name of the validator
  end

  def presence_error_message
    'is not a valid hex color'
  end

  def validate(key, value, _validations, errors)
    unless value.is_a?(String) && valid_hex_color?(value)
      errors[key] = presence_error_message
    end
  end

  private

  def valid_hex_color?(value)
    /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/.match?(value)
  end
end

HashValidator.append_validator(HashValidator::Validator::HexColorValidator.new)