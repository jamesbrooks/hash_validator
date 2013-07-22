require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::BooleanValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "boolean"' do
      validator.should_validate?('boolean').should be_true
    end

    it 'should not validate other names' do
      validator.should_validate?('string').should be_false
      validator.should_validate?('array').should  be_false
      validator.should_validate?(nil).should      be_false
    end
  end

  describe '#validate' do
    it 'should validate a true boolean with true' do
      validator.validate(:key, true, {}, errors)

      errors.should be_empty
    end

    it 'should validate a false boolean with true' do
      validator.validate(:key, false, {}, errors)

      errors.should be_empty
    end

    it 'should validate a nil with false' do
      validator.validate(:key, nil, {}, errors)

      errors.should_not be_empty
      errors.should eq({ key: 'boolean required' })
    end

    it 'should validate a number with false' do
      validator.validate(:key, 123, {}, errors)

      errors.should_not be_empty
      errors.should eq({ key: 'boolean required' })
    end
  end
end
