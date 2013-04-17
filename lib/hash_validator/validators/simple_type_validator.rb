class HashValidator::Validator::SimpleTypeValidator < HashValidator::Validator::Base
  attr_accessor :klass


  def initialize(name, klass)
    super(name)
    self.klass = klass
  end

  def validate(key, value, validations, errors)
    unless value.is_a?(klass)
      errors[key] = presence_error_message
    end
  end
end


# Create simple type validators
[
  [ 'array',   Array   ],
  [ 'numeric', Numeric ],
  [ 'string',  String  ],
  [ 'time',    Time    ]
].each { |name, klass| HashValidator.append_validator(HashValidator::Validator::SimpleTypeValidator.new(name, klass)) }
