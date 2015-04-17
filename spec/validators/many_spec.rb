require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator)  { HashValidator::Validator::ManyValidator.new }
  let(:errors)     { Hash.new }

  def many(validation)
    HashValidator::Validations::Many.new(validation)
  end

  describe '#should_validate?' do
    it 'should validate an Many validation' do
      expect(validator.should_validate?(many('string'))).to eq true
    end

    it 'should not validate other things' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should accept an empty array' do
      validator.validate(:key, [], many('string'), errors)

      expect(errors).to be_empty
    end

    it 'should accept an array of matching elements' do
      validator.validate(:key, ['a', 'b'], many('string'), errors)

      expect(errors).to be_empty
    end

    it 'should not accept an array including a non-matching element' do
      validator.validate(:key, ['a', 2], many('string'), errors)

      expect(errors).to eq({ key: [nil, 'string required'] })
    end

    it 'should accept an array of matching hashes' do
      validator.validate(:key, [{v: 'a'}, {v: 'b'}], many({v: 'string'}), errors)

      expect(errors).to be_empty
    end

    it 'should not accept an array including a non-matching element' do
      validator.validate(:key, [{v: 'a'}, {v: 2}], many({v: 'string'}), errors)

      expect(errors).to eq({ key: [nil, {v: 'string required'}] })
    end

    it 'should not accept a non-enumerable' do
      validator.validate(:key, 'a', many({v: 'string'}), errors)

      expect(errors).to eq({ key: 'enumerable required' })
    end
  end
end
