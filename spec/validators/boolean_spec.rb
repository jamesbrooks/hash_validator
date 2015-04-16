require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::BooleanValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "boolean"' do
      expect(validator.should_validate?('boolean')).to eq true
    end

    it 'should not validate other names' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should validate a true boolean with true' do
      validator.validate(:key, true, {}, errors)

      expect(errors).to be_empty
    end

    it 'should validate a false boolean with true' do
      validator.validate(:key, false, {}, errors)

      expect(errors).to be_empty
    end

    it 'should validate a nil with false' do
      validator.validate(:key, nil, {}, errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'boolean required' })
    end

    it 'should validate a number with false' do
      validator.validate(:key, 123, {}, errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'boolean required' })
    end
  end
end
