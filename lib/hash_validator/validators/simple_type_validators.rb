[
  [ 'array',   Array   ],
  [ 'numeric', Numeric ],
  [ 'string',  String  ],
  [ 'time',    Time    ]
].each do |name, klass|
  HashValidator.append_validator(HashValidator::Validator::SimpleValidator.new(name, lambda { |v| v.is_a?(klass) }))
end
