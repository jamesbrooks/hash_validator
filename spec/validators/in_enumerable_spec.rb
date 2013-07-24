require 'spec_helper'

describe 'Enumerable validator' do
  describe 'Accepting Enumerables in validations' do
    it 'should accept an empty array' do
      validate({}, { foo: [] })
    end

    it 'should accept an array' do
      validate({}, { foo: [ 'apple', 'banana', 'carrot' ] })
    end

    it 'should accept a hash' do
      validate({}, { foo: { apple: 'apple', banana: 'banana', carrot: 'cattot' } })
    end
  end

  describe '#validate' do
    describe 'Simple Array' do
      let(:validations) {{ fruit: [ 'apple', 'banana', 'carrot' ] }}

      it 'should validate true if the value is present' do
        validate({ fruit: 'apple' }, validations).valid?.should be_true
      end

      it 'should validate false if the value is not present' do
        validate({ fruit: 'pear' }, validations).valid?.should be_false
      end

      it 'should validate false if the key is not present' do
        validate({ something: 'apple' }, validations).valid?.should be_false
      end

      it 'should provide an appropriate error message is the value is not present' do
        validate({ fruit: 'pear' }, validations).errors.should eq({ fruit: 'value from list required' })
      end
    end

    describe 'Range' do
      let(:validations) {{ number: 1..10 }}

      it 'should validate true if the value is present' do
        validate({ number: 5 }, validations).valid?.should be_true
      end
      it 'should validate false if the value is not present' do
        validate({ number: 15 }, validations).valid?.should be_false
      end
    end

    describe 'Infinite Range' do
      let(:validations) {{ number: 1..Float::INFINITY }}

      it 'should validate true if the value is present' do
        validate({ number: 5 }, validations).valid?.should be_true
      end
      it 'should validate false if the value is not present' do
        validate({ number: -5 }, validations).valid?.should be_false
      end
    end
  end
end
