require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::PresenceValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "required"' do
      validator.should_validate?('required').should be_true
    end

    it 'should not validate other names' do
      validator.should_validate?('string').should be_false
      validator.should_validate?('array').should  be_false
      validator.should_validate?(nil).should      be_false
    end
  end

  describe '#validate' do
    it 'should validate a string with true' do
      validator.validate(:key, 'test', {}, errors)

      errors.should be_empty
    end

    it 'should validate a number with true' do
      validator.validate(:key, 123, {}, errors)

      errors.should be_empty
    end

    it 'should validate a time with true' do
      validator.validate(:key, Time.now, {}, errors)

      errors.should be_empty
    end

    it 'should validate nil with false' do
      validator.validate(:key, nil, {}, errors)

      errors.should_not be_empty
      errors.should eq({ key: 'is required' })
    end
  end
end
