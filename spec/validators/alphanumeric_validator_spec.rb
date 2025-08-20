require 'spec_helper'

describe HashValidator::Validator::AlphanumericValidator do
  let(:validator) { HashValidator::Validator::AlphanumericValidator.new }

  context 'valid alphanumeric strings' do
    it 'validates letters only' do
      errors = {}
      validator.validate('key', 'abc', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates numbers only' do
      errors = {}
      validator.validate('key', '123', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates mixed letters and numbers' do
      errors = {}
      validator.validate('key', 'abc123', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates uppercase letters' do
      errors = {}
      validator.validate('key', 'ABC', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates mixed case letters' do
      errors = {}
      validator.validate('key', 'AbC123', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates single character' do
      errors = {}
      validator.validate('key', 'a', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates single digit' do
      errors = {}
      validator.validate('key', '1', {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid alphanumeric strings' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects strings with spaces' do
      errors = {}
      validator.validate('key', 'abc 123', {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects strings with special characters' do
      errors = {}
      validator.validate('key', 'abc!123', {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects strings with hyphens' do
      errors = {}
      validator.validate('key', 'abc-123', {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects strings with underscores' do
      errors = {}
      validator.validate('key', 'abc_123', {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end

    it 'rejects strings with periods' do
      errors = {}
      validator.validate('key', 'abc.123', {}, errors)
      expect(errors['key']).to eq('must contain only letters and numbers')
    end
  end
end