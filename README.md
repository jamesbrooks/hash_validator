# Hash Validator

[![Gem](https://img.shields.io/gem/v/hash_validator.svg)](https://rubygems.org/gems/hash_validator)
![Unit Tests](https://github.com/jamesbrooks/hash_validator/actions/workflows/ruby.yml/badge.svg)
[![Maintainability](https://qlty.sh/gh/jamesbrooks/projects/hash_validator/maintainability.svg)](https://qlty.sh/gh/jamesbrooks/projects/hash_validator)
[![Code Coverage](https://qlty.sh/gh/jamesbrooks/projects/hash_validator/coverage.svg)](https://qlty.sh/gh/jamesbrooks/projects/hash_validator)

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

Allows custom defined validations (must inherit from `HashValidator::Validator::Base`).

### Simple Example (using `valid?`)

For simple boolean validations, implement the `valid?` method:

```ruby
# Define our custom validator
class HashValidator::Validator::OddValidator < HashValidator::Validator::Base
  def initialize
    super('odd')  # The name of the validator
  end

  def error_message
    'must be an odd number'
  end

  def valid?(value)
    value.is_a?(Integer) && value.odd?
  end
end

# Add the validator
HashValidator.add_validator(HashValidator::Validator::OddValidator.new)

# Now the validator can be used!
validator = HashValidator.validate({ age: 27 }, { age: 'odd' })
validator.valid?  # => true
validator.errors  # => {}

validator = HashValidator.validate({ age: 26 }, { age: 'odd' })
validator.valid?  # => false
validator.errors  # => { age: 'must be an odd number' }
```

### Complex Example (using `validate`)

For more complex validations that need access to the validation parameters or custom error handling, override the `validate` method:

```ruby
# Define a validator that checks if a number is within a range
class HashValidator::Validator::RangeValidator < HashValidator::Validator::Base
  def initialize
    super('_range')  # Underscore prefix as it's invoked through the validation parameter
  end

  def should_validate?(validation)
    validation.is_a?(Range)
  end

  def error_message
    'is out of range'
  end

  def validate(key, value, range, errors)
    unless range.include?(value)
      errors[key] = "must be between #{range.min} and #{range.max}"
    end
  end
end

# Add the validator
HashValidator.add_validator(HashValidator::Validator::RangeValidator.new)

# Now the validator can be used with Range objects!
validator = HashValidator.validate({ age: 25 }, { age: 18..65 })
validator.valid?  # => true
validator.errors  # => {}

validator = HashValidator.validate({ age: 10 }, { age: 18..65 })
validator.valid?  # => false
validator.errors  # => { age: 'must be between 18 and 65' }
```

## Simple Custom Validators

For simpler use cases, you can define custom validators without creating a full class using pattern matching or custom functions.

### Configuration DSL

Use the configuration DSL to define multiple validators at once, similar to a Rails initializer:

```ruby
# In a Rails app, this would go in config/initializers/hash_validator.rb
HashValidator.configure do |config|
  # Add instance-based validators
  config.add_validator HashValidator::Validator::CustomValidator.new

  # Add pattern-based validators
  config.add_validator 'phone',
    pattern: /\A\+?[1-9]\d{1,14}\z/,
    error_message: 'must be a valid international phone number'

  config.add_validator 'postal_code',
    pattern: /\A[A-Z0-9]{3,10}\z/i,
    error_message: 'must be a valid postal code'

  # Add function-based validators
  config.add_validator 'adult',
    func: ->(age) { age.is_a?(Integer) && age >= 18 },
    error_message: 'must be 18 or older'

  config.add_validator 'business_hours',
    func: ->(hour) { hour.between?(9, 17) },
    error_message: 'must be between 9 AM and 5 PM'
end
```

### Pattern-Based Validators

Use regular expressions to validate string formats:

```ruby
# Add a validator for odd numbers using a pattern
HashValidator.add_validator('odd_string',
  pattern: /\A\d*[13579]\z/,
  error_message: 'must be an odd number string')

# Add a validator for US phone numbers
HashValidator.add_validator('us_phone',
  pattern: /\A\d{3}-\d{3}-\d{4}\z/,
  error_message: 'must be a valid US phone number (XXX-XXX-XXXX)')

# Use the validators
validator = HashValidator.validate(
  { number: '27', phone: '555-123-4567' },
  { number: 'odd_string', phone: 'us_phone' }
)
validator.valid?  # => true

validator = HashValidator.validate(
  { number: '26', phone: '5551234567' },
  { number: 'odd_string', phone: 'us_phone' }
)
validator.valid?  # => false
validator.errors  # => { number: 'must be an odd number string', phone: 'must be a valid US phone number (XXX-XXX-XXXX)' }
```

### Function-Based Validators

Use lambdas or procs for custom validation logic:

```ruby
# Add a validator for adult age using a lambda
HashValidator.add_validator('adult_age',
  func: ->(age) { age.is_a?(Integer) && age >= 18 },
  error_message: 'must be 18 or older')

# Add a validator for palindromes using a proc
HashValidator.add_validator('palindrome',
  func: proc { |str| str.to_s == str.to_s.reverse },
  error_message: 'must be a palindrome')

# Use the validators
validator = HashValidator.validate(
  { age: 25, word: 'racecar' },
  { age: 'adult_age', word: 'palindrome' }
)
validator.valid?  # => true

validator = HashValidator.validate(
  { age: 16, word: 'hello' },
  { age: 'adult_age', word: 'palindrome' }
)
validator.valid?  # => false
validator.errors  # => { age: 'must be 18 or older', word: 'must be a palindrome' }
```

### Removing Custom Validators

You can remove custom validators when they're no longer needed:

```ruby
# Remove a specific validator
HashValidator.remove_validator('adult_age')
```

These simple validators are ideal for:
- Quick format validation without regex in your main code
- Reusable validation logic across your application
- Keeping validation definitions close to your configuration
- Avoiding the overhead of creating full validator classes for simple rules

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
