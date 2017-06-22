require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator)  { HashValidator::Validator::MultipleValidator.new }
  let(:errors)     { Hash.new }

  def multiple(*validations)
    HashValidator::Validations::Multiple.new(validations)
  end

  describe '#should_validate?' do
    it 'should validate an Multiple validation' do
      expect(validator.should_validate?(multiple('numeric', 1..10))).to eq true
    end

    it 'should not validate other things' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should accept an empty collection of validators' do
      validator.validate(:key, 73, multiple(), errors)

      expect(errors).to be_empty
    end

    it 'should accept an collection of validators' do
      validator.validate(:key, 73, multiple('numeric', 1..100), errors)

      expect(errors).to be_empty
    end
  end
end
