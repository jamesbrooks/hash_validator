require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::EmailValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "email"' do
      expect(validator.should_validate?('email')).to eq true
    end

    it 'should not validate other names' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should validate an email with true' do
      validator.validate(:key, "johndoe@gmail.com", {}, errors)

      expect(errors).to be_empty
    end

    it 'should validate a string without an @ symbol with false' do
      validator.validate(:key, 'test', {}, errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'is not a valid email' })
    end

    it 'should validate a number with false' do
      validator.validate(:key, 123, {}, errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'is not a valid email' })
    end
  end
end
