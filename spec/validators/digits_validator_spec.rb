require 'spec_helper'

describe HashValidator::Validator::DigitsValidator do
  let(:validator) { HashValidator::Validator::DigitsValidator.new }

  context 'valid digit strings' do
    it 'validates single digit' do
      errors = {}
      validator.validate('key', '1', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates multiple digits' do
      errors = {}
      validator.validate('key', '123', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates zero' do
      errors = {}
      validator.validate('key', '0', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates long number strings' do
      errors = {}
      validator.validate('key', '1234567890', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates leading zeros' do
      errors = {}
      validator.validate('key', '0123', {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid digit strings' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects strings with letters' do
      errors = {}
      validator.validate('key', '123abc', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects strings with spaces' do
      errors = {}
      validator.validate('key', '123 456', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects strings with special characters' do
      errors = {}
      validator.validate('key', '123!', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects strings with hyphens' do
      errors = {}
      validator.validate('key', '123-456', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects strings with periods' do
      errors = {}
      validator.validate('key', '123.456', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects negative signs' do
      errors = {}
      validator.validate('key', '-123', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end

    it 'rejects positive signs' do
      errors = {}
      validator.validate('key', '+123', {}, errors)
      expect(errors['key']).to eq('must contain only digits')
    end
  end
end