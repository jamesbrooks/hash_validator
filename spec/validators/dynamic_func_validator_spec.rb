require 'spec_helper'

describe HashValidator::Validator::DynamicFuncValidator do
  describe 'Function-based validator' do
    let(:odd_func_validator) do
      HashValidator::Validator::DynamicFuncValidator.new(
        'odd_func',
        ->(n) { n.is_a?(Integer) && n.odd? },
        'is not an odd integer'
      )
    end

    let(:range_validator) do
      HashValidator::Validator::DynamicFuncValidator.new(
        'in_range',
        ->(n) { n.is_a?(Numeric) && n >= 18 && n <= 65 },
        'must be between 18 and 65'
      )
    end

    let(:custom_validator) do
      HashValidator::Validator::DynamicFuncValidator.new(
        'custom',
        proc { |v| v.to_s.length > 5 },
        'must be longer than 5 characters'
      )
    end

    let(:errors) { Hash.new }

    describe '#initialize' do
      it 'requires a callable object' do
        expect {
          HashValidator::Validator::DynamicFuncValidator.new('test', 'not_callable')
        }.to raise_error(ArgumentError, 'Function must be callable (proc or lambda)')
      end

      it 'accepts a lambda' do
        validator = HashValidator::Validator::DynamicFuncValidator.new(
          'test',
          ->(v) { true }
        )
        expect(validator.func).to respond_to(:call)
      end

      it 'accepts a proc' do
        validator = HashValidator::Validator::DynamicFuncValidator.new(
          'test',
          proc { |v| true }
        )
        expect(validator.func).to respond_to(:call)
      end

      it 'accepts a custom error message' do
        validator = HashValidator::Validator::DynamicFuncValidator.new(
          'test',
          ->(v) { true },
          'custom error'
        )
        expect(validator.error_message).to eq('custom error')
      end

      it 'uses default error message when none provided' do
        validator = HashValidator::Validator::DynamicFuncValidator.new(
          'test',
          ->(v) { true }
        )
        expect(validator.error_message).to eq('test required')
      end
    end

    describe '#should_validate?' do
      it 'validates the correct name' do
        expect(odd_func_validator.should_validate?('odd_func')).to eq true
      end

      it 'does not validate other names' do
        expect(odd_func_validator.should_validate?('even_func')).to eq false
        expect(odd_func_validator.should_validate?('string')).to eq false
      end
    end

    describe '#validate' do
      context 'with odd number function' do
        it 'validates odd integers correctly' do
          odd_func_validator.validate(:key, 1, {}, errors)
          expect(errors).to be_empty

          errors.clear
          odd_func_validator.validate(:key, 13, {}, errors)
          expect(errors).to be_empty

          errors.clear
          odd_func_validator.validate(:key, -7, {}, errors)
          expect(errors).to be_empty
        end

        it 'rejects even integers' do
          odd_func_validator.validate(:key, 2, {}, errors)
          expect(errors).to eq({ key: 'is not an odd integer' })

          errors.clear
          odd_func_validator.validate(:key, 100, {}, errors)
          expect(errors).to eq({ key: 'is not an odd integer' })
        end

        it 'rejects non-integers' do
          odd_func_validator.validate(:key, 1.5, {}, errors)
          expect(errors).to eq({ key: 'is not an odd integer' })

          errors.clear
          odd_func_validator.validate(:key, '1', {}, errors)
          expect(errors).to eq({ key: 'is not an odd integer' })
        end
      end

      context 'with range validator' do
        it 'validates numbers in range' do
          range_validator.validate(:key, 18, {}, errors)
          expect(errors).to be_empty

          errors.clear
          range_validator.validate(:key, 30, {}, errors)
          expect(errors).to be_empty

          errors.clear
          range_validator.validate(:key, 65, {}, errors)
          expect(errors).to be_empty

          errors.clear
          range_validator.validate(:key, 25.5, {}, errors)
          expect(errors).to be_empty
        end

        it 'rejects numbers outside range' do
          range_validator.validate(:key, 17, {}, errors)
          expect(errors).to eq({ key: 'must be between 18 and 65' })

          errors.clear
          range_validator.validate(:key, 66, {}, errors)
          expect(errors).to eq({ key: 'must be between 18 and 65' })

          errors.clear
          range_validator.validate(:key, -5, {}, errors)
          expect(errors).to eq({ key: 'must be between 18 and 65' })
        end

        it 'rejects non-numeric values' do
          range_validator.validate(:key, 'twenty', {}, errors)
          expect(errors).to eq({ key: 'must be between 18 and 65' })
        end
      end

      context 'with custom validator using proc' do
        it 'validates strings longer than 5 chars' do
          custom_validator.validate(:key, 'hello world', {}, errors)
          expect(errors).to be_empty

          errors.clear
          custom_validator.validate(:key, 'testing', {}, errors)
          expect(errors).to be_empty
        end

        it 'rejects strings 5 chars or shorter' do
          custom_validator.validate(:key, 'hello', {}, errors)
          expect(errors).to eq({ key: 'must be longer than 5 characters' })

          errors.clear
          custom_validator.validate(:key, 'hi', {}, errors)
          expect(errors).to eq({ key: 'must be longer than 5 characters' })
        end

        it 'converts values to strings' do
          custom_validator.validate(:key, 123456, {}, errors)
          expect(errors).to be_empty

          errors.clear
          custom_validator.validate(:key, 12345, {}, errors)
          expect(errors).to eq({ key: 'must be longer than 5 characters' })
        end
      end

      context 'with function that raises errors' do
        let(:error_func_validator) do
          HashValidator::Validator::DynamicFuncValidator.new(
            'error_func',
            ->(v) { raise 'intentional error' },
            'validation failed'
          )
        end

        it 'treats exceptions as validation failures' do
          error_func_validator.validate(:key, 'any value', {}, errors)
          expect(errors).to eq({ key: 'validation failed' })
        end
      end
    end

    describe 'Integration with HashValidator.add_validator' do
      before do
        HashValidator.add_validator('adult_age', 
          func: ->(age) { age.is_a?(Integer) && age >= 18 }, 
          error_message: 'must be 18 or older')
        
        HashValidator.add_validator('palindrome',
          func: proc { |s| s.to_s == s.to_s.reverse },
          error_message: 'must be a palindrome')
      end

      after do
        HashValidator.remove_validator('adult_age')
        HashValidator.remove_validator('palindrome')
      end

      it 'can register lambda-based validators' do
        validator = HashValidator.validate(
          { age: 25 },
          { age: 'adult_age' }
        )
        expect(validator.valid?).to eq true
        expect(validator.errors).to be_empty
      end

      it 'returns errors for invalid lambda validations' do
        validator = HashValidator.validate(
          { age: 16 },
          { age: 'adult_age' }
        )
        expect(validator.valid?).to eq false
        expect(validator.errors).to eq({ age: 'must be 18 or older' })
      end

      it 'can register proc-based validators' do
        validator = HashValidator.validate(
          { word: 'racecar' },
          { word: 'palindrome' }
        )
        expect(validator.valid?).to eq true
        expect(validator.errors).to be_empty
      end

      it 'returns errors for invalid proc validations' do
        validator = HashValidator.validate(
          { word: 'hello' },
          { word: 'palindrome' }
        )
        expect(validator.valid?).to eq false
        expect(validator.errors).to eq({ word: 'must be a palindrome' })
      end
    end
  end
end