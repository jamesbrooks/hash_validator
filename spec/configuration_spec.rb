require 'spec_helper'

describe 'HashValidator.configure' do
  describe 'configuration DSL' do
    after(:each) do
      # Clean up any validators added during tests
      HashValidator.remove_validator('test_pattern')
      HashValidator.remove_validator('test_func')
      HashValidator.remove_validator('bulk_odd')
      HashValidator.remove_validator('bulk_even')
      HashValidator.remove_validator('bulk_palindrome')
      HashValidator.remove_validator('custom_configured')
    end

    it 'allows adding instance-based validators' do
      class HashValidator::Validator::CustomConfiguredValidator < HashValidator::Validator::Base
        def initialize
          super('custom_configured')
        end
        
        def valid?(value)
          value == 'configured'
        end
      end

      HashValidator.configure do |config|
        config.add_validator HashValidator::Validator::CustomConfiguredValidator.new
      end

      validator = HashValidator.validate(
        { status: 'configured' },
        { status: 'custom_configured' }
      )
      expect(validator.valid?).to eq true
    end

    it 'allows adding pattern-based validators' do
      HashValidator.configure do |config|
        config.add_validator 'test_pattern', 
          pattern: /\A[A-Z]{3}\z/, 
          error_message: 'must be three uppercase letters'
      end

      validator = HashValidator.validate(
        { code: 'ABC' },
        { code: 'test_pattern' }
      )
      expect(validator.valid?).to eq true

      validator = HashValidator.validate(
        { code: 'abc' },
        { code: 'test_pattern' }
      )
      expect(validator.valid?).to eq false
      expect(validator.errors).to eq({ code: 'must be three uppercase letters' })
    end

    it 'allows adding function-based validators' do
      HashValidator.configure do |config|
        config.add_validator 'test_func',
          func: ->(v) { v.is_a?(Integer) && v > 100 },
          error_message: 'must be an integer greater than 100'
      end

      validator = HashValidator.validate(
        { score: 150 },
        { score: 'test_func' }
      )
      expect(validator.valid?).to eq true

      validator = HashValidator.validate(
        { score: 50 },
        { score: 'test_func' }
      )
      expect(validator.valid?).to eq false
      expect(validator.errors).to eq({ score: 'must be an integer greater than 100' })
    end

    it 'allows adding multiple validators in one configure block' do
      HashValidator.configure do |config|
        config.add_validator 'bulk_odd',
          pattern: /\A\d*[13579]\z/,
          error_message: 'must be odd'
        
        config.add_validator 'bulk_even',
          pattern: /\A\d*[02468]\z/,
          error_message: 'must be even'
        
        config.add_validator 'bulk_palindrome',
          func: proc { |s| s.to_s == s.to_s.reverse },
          error_message: 'must be a palindrome'
      end

      # Test odd validator
      validator = HashValidator.validate(
        { num: '13' },
        { num: 'bulk_odd' }
      )
      expect(validator.valid?).to eq true

      # Test even validator
      validator = HashValidator.validate(
        { num: '24' },
        { num: 'bulk_even' }
      )
      expect(validator.valid?).to eq true

      # Test palindrome validator
      validator = HashValidator.validate(
        { word: 'level' },
        { word: 'bulk_palindrome' }
      )
      expect(validator.valid?).to eq true
    end

    it 'allows removing validators within configure block' do
      # First add a validator
      HashValidator.add_validator 'test_pattern',
        pattern: /test/,
        error_message: 'test'

      # Then remove it in configure
      HashValidator.configure do |config|
        config.remove_validator 'test_pattern'
      end

      # Should raise error as validator no longer exists
      expect {
        HashValidator.validate({ value: 'test' }, { value: 'test_pattern' })
      }.to raise_error(StandardError, /Could not find valid validator/)
    end

    it 'works without a block' do
      expect {
        HashValidator.configure
      }.not_to raise_error
    end

    it 'yields a Configuration instance' do
      HashValidator.configure do |config|
        expect(config).to be_a(HashValidator::Configuration)
      end
    end
  end

  describe 'Rails-style initializer example' do
    after(:each) do
      HashValidator.remove_validator('phone')
      HashValidator.remove_validator('postal_code')
      HashValidator.remove_validator('age_range')
    end

    it 'can be used like a Rails initializer' do
      # This would typically be in config/initializers/hash_validator.rb
      HashValidator.configure do |config|
        # Add pattern validators
        config.add_validator 'phone',
          pattern: /\A\+?[1-9]\d{1,14}\z/,
          error_message: 'must be a valid international phone number'
        
        config.add_validator 'postal_code',
          pattern: /\A[A-Z0-9]{3,10}\z/i,
          error_message: 'must be a valid postal code'
        
        # Add function validator
        config.add_validator 'age_range',
          func: ->(age) { age.is_a?(Integer) && age.between?(0, 120) },
          error_message: 'must be between 0 and 120'
      end

      # Use the configured validators
      validator = HashValidator.validate(
        { 
          phone: '+14155551234',
          postal_code: 'SW1A1AA',
          age: 30
        },
        { 
          phone: 'phone',
          postal_code: 'postal_code',
          age: 'age_range'
        }
      )
      
      expect(validator.valid?).to eq true
      expect(validator.errors).to be_empty
    end
  end
end