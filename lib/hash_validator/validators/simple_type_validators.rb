[
  Array,
  Complex,
  Enumerable,
  Float,
  Integer,
  Numeric,
  Range,
  Rational,
  Regexp,
  String,
  Symbol,
  Time
].each do |type|
  name = type.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase  # ActiveSupport/Inflector#underscore behaviour
  HashValidator.append_validator(HashValidator::Validator::SimpleValidator.new(name, lambda { |v| v.is_a?(type) }))
end
