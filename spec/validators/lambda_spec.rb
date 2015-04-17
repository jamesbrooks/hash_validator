require 'spec_helper'

describe 'Functional validator' do
  describe 'Accepting Lambdas in validations' do
    it 'should accept a lambda' do
      validate({}, { foo: lambda { |arg| } })
    end

    it 'should accept a proc' do
      validate({}, { foo: Proc.new { |arg| } })
    end
  end

  describe 'Correct number of arguments for lambads in validations' do
    it 'should accept a lambda with one argument' do
      expect { validate({}, { foo: lambda { |a| } }) }.to_not raise_error
    end

    it 'should not accept a lambda with no arguments' do
      expect { validate({}, { foo: lambda { } }) }.to raise_error(HashValidator::Validator::LambdaValidator::InvalidArgumentCount)
    end

    it 'should not accept a lambda with two arguments' do
      expect { validate({}, { foo: lambda { |a,b| } }) }.to raise_error(HashValidator::Validator::LambdaValidator::InvalidArgumentCount)
    end
  end

  describe '#validate' do
    let(:validations) {{ number: lambda { |n| n.odd? } }}

    it 'should validate true when the number is odd' do
      expect(validate({ number: 1 }, validations).valid?).to eq true
    end

    it 'should validate false when the number is even' do
      expect(validate({ number: 2 }, validations).valid?).to eq false
    end
  end

  describe 'Thrown exceptions from within the lambda' do
    let(:validations) {{ number: lambda { |n| n.odd? } }}

    it 'should validate false when an exception occurs within the lambda' do
      expect(validate({ number: '2' }, validations).valid?).to eq false
    end
  end
end
