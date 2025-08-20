require 'spec_helper'

describe HashValidator::Validator::UrlValidator do
  let(:validator) { HashValidator::Validator::UrlValidator.new }

  context 'valid URLs' do
    it 'validates http URLs' do
      errors = {}
      validator.validate('key', 'http://example.com', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates https URLs' do
      errors = {}
      validator.validate('key', 'https://example.com', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates ftp URLs' do
      errors = {}
      validator.validate('key', 'ftp://ftp.example.com', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates URLs with paths' do
      errors = {}
      validator.validate('key', 'https://example.com/path/to/resource', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates URLs with query parameters' do
      errors = {}
      validator.validate('key', 'https://example.com/search?q=test&page=1', {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid URLs' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('is not a valid URL')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('is not a valid URL')
    end

    it 'rejects malformed URLs' do
      errors = {}
      validator.validate('key', 'not a url', {}, errors)
      expect(errors['key']).to eq('is not a valid URL')
    end

    it 'rejects URLs without schemes' do
      errors = {}
      validator.validate('key', 'example.com', {}, errors)
      expect(errors['key']).to eq('is not a valid URL')
    end

    it 'rejects unsupported schemes' do
      errors = {}
      validator.validate('key', 'mailto:test@example.com', {}, errors)
      expect(errors['key']).to eq('is not a valid URL')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('is not a valid URL')
    end
  end
end