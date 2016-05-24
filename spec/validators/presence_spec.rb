require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::PresenceValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "required"' do
      expect(validator.should_validate?('required')).to eq true
    end

    it 'should not validate other names' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should validate a string with true' do
      validator.validate(:key, 'test', {}, errors)

      expect(errors).to be_empty
    end

    it 'should validate a number with true' do
      validator.validate(:key, 123, {}, errors)

      expect(errors).to be_empty
    end

    it 'should validate a time with true' do
      validator.validate(:key, Time.now, {}, errors)

      expect(errors).to be_empty
    end

    it 'should validate nil with false' do
      validator.validate(:key, nil, {}, errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'is required' })
    end

    it 'should validate false with true' do
      validator.validate(:key, false, {}, errors)

      expect(errors).to be_empty
    end
  end
end
