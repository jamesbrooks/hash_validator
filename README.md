# Hash Validator

[![Gem](https://img.shields.io/gem/v/hash_validator.svg)](https://rubygems.org/gems/hash_validator)
![Unit Tests](https://github.com/jamesbrooks/hash_validator/actions/workflows/ruby.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/dc6edc1b240860c5f5d9/maintainability)](https://codeclimate.com/github/JamesBrooks/hash_validator/maintainability)

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
    first_name: String,
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

* `array`
* `boolean`
* `complex`
* `enumerable`
* `float`
* `integer`
* `numeric`
* `range`
* `rational`
* `regexp`
* `string`
* `symbol`
* `time`
* `required`: just requires any value to be present for the designated key.
* hashes are validates by nesting validations, or if just the presence of a hash is required `{}` can be used.

On top of the pre-defined simple types, classes can be used directly (e.g. String) to validate the presence of a value of a desired class.

Additional validations exist to validate beyond simple typing, such as:

* An Enumerable instance: validates that the value is contained within the supplied enumerable.
* A lambda/Proc instance: validates that the lambda/proc returns true when the value is supplied (lambdas must accept only one argument).
* A regexp instance: validates that the regex returns a match when the value is supplied (Regexp#match(value) is not nil).
* `email`: email address validation (string + email address).

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

## Multiple validators

Multiple validators can be applied to a single key, e.g.

```ruby
HashValidator.validate(
  { foo: 73 },
  { foo: HashValidator.multiple('numeric', 1..100) }
)
```

This is particularly useful when defining custom validators.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
