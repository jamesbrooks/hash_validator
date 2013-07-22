require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::EmailValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "email"' do
      validator.should_validate?('email').should be_true
    end

    it 'should not validate other names' do
      validator.should_validate?('string').should be_false
      validator.should_validate?('array').should  be_false
      validator.should_validate?(nil).should      be_false
    end
  end

  describe '#validate' do
    it 'should validate an email with true' do
      validator.validate(:key, "johndoe@gmail.com", {}, errors)

      errors.should be_empty
    end

    it 'should validate a string without an @ symbol with false' do
      validator.validate(:key, 'test', {}, errors)

      errors.should_not be_empty
      errors.should eq({ key: 'is not a valid email' })
    end

    it 'should validate a number with false' do
      validator.validate(:key, 123, {}, errors)

      errors.should_not be_empty
      errors.should eq({ key: 'is not a valid email' })
    end
  end
end
