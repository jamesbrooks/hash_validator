# Hash Validator

[![Gem](https://img.shields.io/gem/v/hash_validator.svg)](https://rubygems.org/gems/hash_validator)
![Unit Tests](https://github.com/jamesbrooks/hash_validator/actions/workflows/ruby.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/dc6edc1b240860c5f5d9/maintainability)](https://codeclimate.com/github/JamesBrooks/hash_validator/maintainability)

Ruby library to validate hashes (Hash) against user-defined requirements

## Requirements

* Ruby 3.0+

## Installation

Add this line to your application's Gemfile:

    gem 'hash_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_validator

## Quick Start

```ruby
require 'hash_validator'

# Define validation rules
validations = { name: 'string', age: 'integer', email: 'email' }

# Validate a hash
validator = HashValidator.validate(
  { name: 'John', age: 30, email: 'john@example.com' },
  validations
)

validator.valid?  # => true
```

## Examples

### Successful Validation
```ruby
validations = { name: 'string', active: 'boolean', tags: 'array' }
hash = { name: 'Product', active: true, tags: ['new', 'featured'] }

validator = HashValidator.validate(hash, validations)
validator.valid?  # => true
validator.errors  # => {}
```

### Failed Validation
```ruby
validations = { 
  user: {
    first_name: 'string',
    age: 'integer',
    email: 'email'
  }
}

hash = { 
  user: {
    first_name: 'James',
    age: 'thirty',  # Should be integer
    # email missing
  }
}

validator = HashValidator.validate(hash, validations)
validator.valid?  # => false
validator.errors  # => { user: { age: "integer required", email: "email required" } }
```

### Rails Controller Example
```ruby
class UsersController < ApplicationController
  def create
    validations = {
      user: {
        name: 'string',
        email: 'email',
        age: 'integer',
        website: 'url',
        preferences: {
          theme: ['light', 'dark'],
          notifications: 'boolean'
        }
      }
    }
    
    validator = HashValidator.validate(params, validations)
    
    if validator.valid?
      user = User.create(params[:user])
      render json: { user: user }, status: :created
    else
      render json: { errors: validator.errors }, status: :unprocessable_entity
    end
  end
end

# Example request that would pass validation:
# POST /users
# {
#   "user": {
#     "name": "John Doe",
#     "email": "john@example.com", 
#     "age": 30,
#     "website": "https://johndoe.com",
#     "preferences": {
#       "theme": "dark",
#       "notifications": true
#     }
#   }
# }
```

## Usage

Define a validation hash which will be used to validate. This hash can be nested as deeply as required using the following validators:

| Validator | Validation Configuration | Example Valid Payload |
|-----------|-------------------------|----------------------|
| `alpha` | `{ name: 'alpha' }` | `{ name: 'James' }` |
| `alphanumeric` | `{ username: 'alphanumeric' }` | `{ username: 'user123' }` |
| `array` | `{ tags: 'array' }` | `{ tags: ['ruby', 'rails'] }` |
| `boolean` | `{ active: 'boolean' }` | `{ active: true }` |
| `complex` | `{ number: 'complex' }` | `{ number: Complex(1, 2) }` |
| `digits` | `{ zip_code: 'digits' }` | `{ zip_code: '12345' }` |
| `email` | `{ contact: 'email' }` | `{ contact: 'user@example.com' }` |
| `enumerable` | `{ status: ['active', 'inactive'] }` | `{ status: 'active' }` |
| `float` | `{ price: 'float' }` | `{ price: 19.99 }` |
| `hex_color` | `{ color: 'hex_color' }` | `{ color: '#ff0000' }` |
| `integer` | `{ age: 'integer' }` | `{ age: 25 }` |
| `ip` | `{ address: 'ip' }` | `{ address: '192.168.1.1' }` |
| `ipv4` | `{ address: 'ipv4' }` | `{ address: '10.0.0.1' }` |
| `ipv6` | `{ address: 'ipv6' }` | `{ address: '2001:db8::1' }` |
| `json` | `{ config: 'json' }` | `{ config: '{"theme": "dark"}' }` |
| `numeric` | `{ score: 'numeric' }` | `{ score: 95.5 }` |
| `range` | `{ priority: 1..10 }` | `{ priority: 5 }` |
| `rational` | `{ ratio: 'rational' }` | `{ ratio: Rational(3, 4) }` |
| `regexp` | `{ code: /^[A-Z]{3}$/ }` | `{ code: 'ABC' }` |
| `required` | `{ id: 'required' }` | `{ id: 'any_value' }` |
| `string` | `{ title: 'string' }` | `{ title: 'Hello World' }` |
| `symbol` | `{ type: 'symbol' }` | `{ type: :user }` |
| `time` | `{ created_at: 'time' }` | `{ created_at: Time.now }` |
| `url` | `{ website: 'url' }` | `{ website: 'https://example.com' }` |

For hash validation, use nested validations or `{}` to just require a hash to be present.

## Advanced Features

### Class Validation
On top of the pre-defined validators, classes can be used directly to validate the presence of a value of a specific class:

```ruby
validations = { created_at: Time, user_id: Integer }
hash = { created_at: Time.now, user_id: 123 }
HashValidator.validate(hash, validations).valid?  # => true
```

### Enumerable Validation
Validate that a value is contained within a supplied enumerable:

```ruby
validations = { status: ['active', 'inactive', 'pending'] }
hash = { status: 'active' }
HashValidator.validate(hash, validations).valid?  # => true
```

### Lambda/Proc Validation
Use custom logic with lambdas or procs (must accept only one argument):

```ruby
validations = { age: ->(value) { value.is_a?(Integer) && value >= 18 } }
hash = { age: 25 }
HashValidator.validate(hash, validations).valid?  # => true
```

### Regular Expression Validation
Validate that a string matches a regex pattern:

```ruby
validations = { product_code: /^[A-Z]{2}\d{4}$/ }
hash = { product_code: 'AB1234' }
HashValidator.validate(hash, validations).valid?  # => true
```

### Multiple Validators
Apply multiple validators to a single key:

```ruby
HashValidator.validate(
  { score: 85 },
  { score: HashValidator.multiple('numeric', 1..100) }
).valid?  # => true
```

This is particularly useful when combining built-in validators with custom validation logic.

## Custom Validations

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
