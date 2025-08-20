require 'spec_helper'

describe HashValidator::Validator::JsonValidator do
  let(:validator) { HashValidator::Validator::JsonValidator.new }

  context 'valid JSON' do
    it 'validates simple JSON objects' do
      errors = {}
      validator.validate('key', '{"name": "test"}', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates JSON arrays' do
      errors = {}
      validator.validate('key', '[1, 2, 3]', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates JSON strings' do
      errors = {}
      validator.validate('key', '"hello world"', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates JSON numbers' do
      errors = {}
      validator.validate('key', '42', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates JSON booleans' do
      errors = {}
      validator.validate('key', 'true', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates JSON null' do
      errors = {}
      validator.validate('key', 'null', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates complex nested JSON' do
      errors = {}
      json_string = '{"users": [{"name": "John", "age": 30}, {"name": "Jane", "age": 25}]}'
      validator.validate('key', json_string, {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid JSON' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('is not valid JSON')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('is not valid JSON')
    end

    it 'rejects malformed JSON' do
      errors = {}
      validator.validate('key', '{"name": "test"', {}, errors)
      expect(errors['key']).to eq('is not valid JSON')
    end

    it 'rejects invalid JSON syntax' do
      errors = {}
      validator.validate('key', '{name: "test"}', {}, errors)
      expect(errors['key']).to eq('is not valid JSON')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('is not valid JSON')
    end

    it 'rejects plain text' do
      errors = {}
      validator.validate('key', 'hello world', {}, errors)
      expect(errors['key']).to eq('is not valid JSON')
    end
  end
end