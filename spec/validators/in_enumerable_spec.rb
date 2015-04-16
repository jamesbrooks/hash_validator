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
        expect(validate({ fruit: 'apple' }, validations).valid?).to eq true
      end

      it 'should validate false if the value is not present' do
        expect(validate({ fruit: 'pear' }, validations).valid?).to eq false
      end

      it 'should validate false if the key is not present' do
        expect(validate({ something: 'apple' }, validations).valid?).to eq false
      end

      it 'should provide an appropriate error message is the value is not present' do
        expect(validate({ fruit: 'pear' }, validations).errors).to eq({ fruit: 'value from list required' })
      end
    end

    describe 'Range' do
      let(:validations) {{ number: 1..10 }}

      it 'should validate true if the value is present' do
        expect(validate({ number: 5 }, validations).valid?).to eq true
      end
      it 'should validate false if the value is not present' do
        expect(validate({ number: 15 }, validations).valid?).to eq false
      end
    end

    describe 'Infinite Range' do
      let(:validations) {{ number: 1..Float::INFINITY }}

      it 'should validate true if the value is present' do
        expect(validate({ number: 5 }, validations).valid?).to eq true
      end
      it 'should validate false if the value is not present' do
        expect(validate({ number: -5 }, validations).valid?).to eq false
      end
    end

    describe 'nil values' do
      let(:validations) {{ fruit: [ nil, :apple, :banana ] }}

      it 'should validate true if a nil value is present' do
        expect(validate({ fruit: nil }, validations).valid?).to eq true
      end
    end
  end
end
