require 'spec_helper'

describe 'Regular expression validator' do
  describe 'Accepting RegExps in validations' do
    it 'should accept a regexp' do
      validate({}, { foo: // })
    end
  end

  describe '#validate' do
    let(:validations) {{ string: /^foo$/ }}

    it 'should validate true when the value is foo' do
      expect(validate({ string: 'foo' }, validations).valid?).to eq true
    end

    it 'should validate false when the value is not foo' do
      expect(validate({ string: 'bar' }, validations).valid?).to eq false
      expect(validate({ string: ' foo' }, validations).valid?).to eq false
      expect(validate({ string: 'foo ' }, validations).valid?).to eq false
      expect(validate({ string: nil }, validations).valid?).to eq false
      expect(validate({ string: 0 }, validations).valid?).to eq false
      expect(validate({ string: true }, validations).valid?).to eq false
    end
  end
end
