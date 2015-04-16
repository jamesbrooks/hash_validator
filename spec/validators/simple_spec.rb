require 'spec_helper'

describe HashValidator::Validator::SimpleValidator do
  describe '#initialize' do
    it 'accepts blocks with one argument' do
      expect {
        HashValidator::Validator::SimpleValidator.new('name', lambda { |a| true })
      }.to_not raise_error
    end

    it 'does not accept blocks with no arguments' do
      expect {
        HashValidator::Validator::SimpleValidator.new('name', lambda { true })
      }.to raise_error(StandardError, 'lambda should take only one argument - passed lambda takes 0')
    end

    it 'does not accept blocks with two arguments' do
      expect {
        HashValidator::Validator::SimpleValidator.new('name', lambda { |a,b| true })
      }.to raise_error(StandardError, 'lambda should take only one argument - passed lambda takes 2')
    end
  end

  describe '#validate' do
    # Lambda that accepts strings that are 4 characters or shorter
    let(:short_string_lambda)    { lambda { |v| v.is_a?(String) && v.size < 5 } }
    let(:short_string_validator) { HashValidator::Validator::SimpleValidator.new('short_string', short_string_lambda) }
    let(:errors)                 { Hash.new }

    [ '', '1', '12', '123', '1234' ].each do |value|
      it "validates the string '#{value}'" do
        short_string_validator.validate(:key, value, {}, errors)

        expect(errors).to be_empty
      end
    end

    [ nil, '12345', '123456', 123, 123456, Time.now, (1..5) ].each do |value|
      it "does not validate bad value '#{value}'" do
        short_string_validator.validate(:key, value, {}, errors)

        expect(errors).to eq({ key: 'short_string required' })
      end
    end
  end
end
