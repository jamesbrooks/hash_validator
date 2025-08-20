require 'spec_helper'

describe HashValidator::Validator::HexColorValidator do
  let(:validator) { HashValidator::Validator::HexColorValidator.new }

  context 'valid hex colors' do
    it 'validates 6-digit hex colors (lowercase)' do
      errors = {}
      validator.validate('key', '#ff0000', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates 6-digit hex colors (uppercase)' do
      errors = {}
      validator.validate('key', '#FF0000', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates 6-digit hex colors (mixed case)' do
      errors = {}
      validator.validate('key', '#Ff0000', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates 3-digit hex colors (lowercase)' do
      errors = {}
      validator.validate('key', '#f00', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates 3-digit hex colors (uppercase)' do
      errors = {}
      validator.validate('key', '#F00', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates black color' do
      errors = {}
      validator.validate('key', '#000000', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates white color' do
      errors = {}
      validator.validate('key', '#ffffff', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates complex hex colors' do
      errors = {}
      validator.validate('key', '#3a7bd4', {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid hex colors' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects hex colors without hash' do
      errors = {}
      validator.validate('key', 'ff0000', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects invalid length (4 digits)' do
      errors = {}
      validator.validate('key', '#ff00', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects invalid length (5 digits)' do
      errors = {}
      validator.validate('key', '#ff000', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects invalid length (7 digits)' do
      errors = {}
      validator.validate('key', '#ff00000', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects invalid characters' do
      errors = {}
      validator.validate('key', '#gg0000', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end

    it 'rejects just hash symbol' do
      errors = {}
      validator.validate('key', '#', {}, errors)
      expect(errors['key']).to eq('is not a valid hex color')
    end
  end
end