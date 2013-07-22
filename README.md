# Hash Validator

[![Gem Version](https://badge.fury.io/rb/hash_validator.png)](http://badge.fury.io/rb/hash_validator)
[![Build Status](https://travis-ci.org/JamesBrooks/hash_validator.png)](https://travis-ci.org/JamesBrooks/hash_validator)
[![Coverage Status](https://coveralls.io/repos/JamesBrooks/hash_validator/badge.png?branch=master)](https://coveralls.io/r/JamesBrooks/hash_validator)
[![Code Climate](https://codeclimate.com/github/JamesBrooks/hash_validator.png)](https://codeclimate.com/github/JamesBrooks/hash_validator)
[![Dependency Status](https://gemnasium.com/JamesBrooks/hash_validator.png)](https://gemnasium.com/JamesBrooks/hash_validator)

Ruby library to validate hashes (Hash) against user-defined requirements

## Installation

Add this line to your application's Gemfile:

    gem 'hash_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_validator

## Example

```ruby
# Validations hash
validations = {
  user: {
    first_name: 'string',
    last_name:  'string',
    age:        'numeric',
    likes:      'array'
  }
}

# Hash to validate
hash = {
  foo: 1,
  bar: 'baz',
  user: {
    first_name: 'James',
    last_name:  12345
  }
}

validator = HashValidator.validate(hash, validations)

validator.valid?
  # => false

validator.errors
  # {
      :user => {
          :last_name => "string required",
                :age => "numeric required",
              :likes => "array required"
      }
    }
```

## Usage

Define a validation hash which will be used to validate. This has can be nested as deeply as required using the following values to validate specific value types:

* `string`
* `numeric`
* `array`
* `time`
* `required`: just requires any value to be present for the designated key.
* hashes are validates by nesting validations, or if just the presence of a hash is required `{}` can be used.

Additional validations exist to validate beyond simple typing, such as:

* `email`: email address validation (string + email address)

Example use-cases include Ruby APIs (I'm currently using it in a Rails API that I'm building for better error responses to developers).

## Custom validations

Allows custom defined validations (must inherit from `HashValidator::Validator::Base`). Example:

```ruby
# Define our custom validator
class HashValidator::Validator::OddValidator < HashValidator::Validator::Base
  def initialize
    super('odd')  # The name of the validator
  end

  def validate(key, value, validations, errors)
    unless value.is_a?(Integer) && value.odd?
      errors[key] = presence_error_message
    end
  end
end

# Add the validator
HashValidator.append_validator(HashValidator::Validator::OddValidator.new)

# Now the validator can be used! e.g.
validator = HashValidator.validate({ age: 27 }, { age: 'odd' })
validator.valid?  # => true
validator.errors  # => {}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
