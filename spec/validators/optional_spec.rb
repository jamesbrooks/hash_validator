require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator)  { HashValidator::Validator::OptionalValidator.new }
  let(:errors)     { Hash.new }

  def optional(validation)
    HashValidator::Validations::Optional.new(validation)
  end

  describe '#should_validate?' do
    it 'should validate an Optional validation' do
      expect(validator.should_validate?(optional('string'))).to eq true
    end

    it 'should not validate other things' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should accept a missing value' do
      validator.validate(:key, nil, optional('string'), errors)

      expect(errors).to be_empty
    end

    it 'should accept a present, matching value' do
      validator.validate(:key, 'foo', optional('string'), errors)

      expect(errors).to be_empty
    end

    it 'should reject a present, non-matching value' do
      validator.validate(:key, 123, optional('string'), errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'string required' })
    end

    it 'should accept a present, matching hash' do
      validator.validate(:key, {v: 'foo'}, optional({v: 'string'}), errors)

      expect(errors).to be_empty
    end

    it 'should reject a present, non-matching hash' do
      validator.validate(:key, {}, optional({v: 'string'}), errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: {v: 'string required'} })
    end
  end
end
