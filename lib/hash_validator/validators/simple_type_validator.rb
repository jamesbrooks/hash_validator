class HashValidator::Validator::SimpleTypeValidator < HashValidator::Validator::Base
  attr_accessor :name, :klass


  def initialize(name, klass)
    self.name  = name
    self.klass = klass
  end

  def should_validate?(rhs)
    rhs == self.name
  end

  def validate(key, value, validations, errors)
    unless value.is_a?(klass)
      errors[key] = "should be #{name}"
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
