require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator)  { HashValidator::Validator::OptionalValidator.new }
  let(:errors)     { Hash.new }

  def optional(validation)
    HashValidator::Validations::Optional.new(validation)
  end

  describe '#should_validate?' do
    it 'should validate an Optional validation' do
      validator.should_validate?(optional('string')).should be_true
    end

    it 'should not validate other things' do
      validator.should_validate?('string').should be_false
      validator.should_validate?('array').should  be_false
      validator.should_validate?(nil).should      be_false
    end
  end

  describe '#validate' do
    it 'should accept a missing value' do
      validator.validate(:key, nil, optional('string'), errors)

      errors.should be_empty
    end

    it 'should accept a present, matching value' do
      validator.validate(:key, 'foo', optional('string'), errors)

      errors.should be_empty
    end

    it 'should reject a present, non-matching value' do
      validator.validate(:key, 123, optional('string'), errors)

      errors.should_not be_empty
      errors.should eq({ key: 'string required' })
    end

    it 'should accept a present, matching hash' do
      validator.validate(:key, {v: 'foo'}, optional({v: 'string'}), errors)

      errors.should be_empty
    end

    it 'should reject a present, non-matching hash' do
      validator.validate(:key, {}, optional({v: 'string'}), errors)

      errors.should_not be_empty
      errors.should eq({ key: {v: 'string required'} })
    end
  end
end
