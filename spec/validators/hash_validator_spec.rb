require 'spec_helper'

describe 'ActionController::Parameters support' do
  # Mock ActionController::Parameters for testing
  let(:mock_params_class) do
    Class.new do
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def [](key)
        @data[key]
      end

      def keys
        @data.keys
      end

      def to_unsafe_h
        @data
      end

      def is_a?(klass)
        return true if klass.name == 'ActionController::Parameters'
        super
      end

      def class
        OpenStruct.new(name: 'ActionController::Parameters')
      end
    end
  end

  before do
    # Define ActionController::Parameters constant for testing
    unless defined?(ActionController::Parameters)
      ActionController = Module.new unless defined?(ActionController)
      ActionController.const_set(:Parameters, mock_params_class)
    end
  end

  it 'should validate ActionController::Parameters objects' do
    params = ActionController::Parameters.new({ name: 'John', age: 30 })
    validations = { name: 'string', age: 'integer' }
    
    validator = HashValidator.validate(params, validations)
    
    expect(validator.valid?).to be true
    expect(validator.errors).to be_empty
  end

  it 'should handle nested ActionController::Parameters' do
    nested_params = ActionController::Parameters.new({ theme: 'dark' })
    params = ActionController::Parameters.new({ 
      name: 'John', 
      preferences: nested_params
    })
    
    validations = { 
      name: 'string',
      preferences: { theme: 'string' }
    }
    
    validator = HashValidator.validate(params, validations)
    
    expect(validator.valid?).to be true
    expect(validator.errors).to be_empty
  end

  it 'should validate ActionController::Parameters with our new validators' do
    params = ActionController::Parameters.new({
      name: 'John',
      email: 'john@example.com',
      website: 'https://john.com',
      zip_code: '12345'
    })
    
    validations = {
      name: 'alpha',
      email: 'email',
      website: 'url',
      zip_code: 'digits'
    }
    
    validator = HashValidator.validate(params, validations)
    
    expect(validator.valid?).to be true
    expect(validator.errors).to be_empty
  end

  it 'should still work with regular hashes' do
    hash = { name: 'John', age: 30 }
    validations = { name: 'string', age: 'integer' }
    
    validator = HashValidator.validate(hash, validations)
    
    expect(validator.valid?).to be true
    expect(validator.errors).to be_empty
  end
end