require 'spec_helper'

describe HashValidator do
  describe 'Adding validators' do
    let(:new_validator1) { HashValidator::Validator::SimpleValidator.new('my_type1', lambda { |v| true }) }
    let(:new_validator2) { HashValidator::Validator::SimpleValidator.new('my_type2', lambda { |v| true }) }

    it 'allows validators with unique names' do
      expect {
        HashValidator.append_validator(new_validator1)
      }.to_not raise_error
    end

    it 'does not allow validators with conflicting names' do
      expect {
        HashValidator.append_validator(new_validator2)
        HashValidator.append_validator(new_validator2)
      }.to raise_error(StandardError, 'validators need to have unique names')
    end

    it 'does not allow validators that do not inherit from the base validator class' do
      expect {
        HashValidator.append_validator('Not a validator')
      }.to raise_error(StandardError, 'validators need to inherit from HashValidator::Validator::Base')
    end
  end

  describe '#validate' do
    describe 'individual type validations' do
      it 'should validate hash' do
        expect(validate({ v: {} }, { v: {} }).valid?).to eq true

        expect(validate({ v: '' }, { v: {} }).valid?).to eq false
        expect(validate({ v: '' }, { v: {} }).errors).to eq({ v: 'hash required' })
      end

      it 'should validate presence' do
        expect(validate({ v: 'test' }, { v: 'required' }).valid?).to eq true
        expect(validate({ v: 1234   }, { v: 'required' }).valid?).to eq true

        expect(validate({ v: nil    }, { v: 'required' }).valid?).to eq false
        expect(validate({ v: nil    }, { v: 'required' }).errors).to eq({ v: 'is required' })

        expect(validate({ x: 'test' }, { v: 'required' }).valid?).to eq false
        expect(validate({ x: 'test' }, { v: 'required' }).errors).to eq({ v: 'is required' })

        expect(validate({ x: 1234   }, { v: 'required' }).valid?).to eq false
        expect(validate({ x: 1234   }, { v: 'required' }).errors).to eq({ v: 'is required' })
      end

      it 'should validate string' do
        expect(validate({ v: 'test' }, { v: 'string' }).valid?).to eq true

        expect(validate({ v: 123456 }, { v: 'string' }).valid?).to eq false
        expect(validate({ v: 123456 }, { v: 'string' }).errors).to eq({ v: 'string required' })
      end

      it 'should validate numeric' do
        expect(validate({ v: 1234 }, { v: 'numeric' }).valid?).to eq true
        expect(validate({ v: '12' }, { v: 'numeric' }).valid?).to eq false
      end

      it 'should validate array' do
        expect(validate({ v: [ 1,2,3 ] }, { v: 'array' }).valid?).to eq true
        expect(validate({ v: ' 1,2,3 ' }, { v: 'array' }).valid?).to eq false
      end

      it 'should validate time' do
        expect(validate({ v: Time.now                    }, { v: 'time' }).valid?).to eq true
        expect(validate({ v: '2013-04-12 13:18:05 +0930' }, { v: 'time' }).valid?).to eq false
      end
    end

    describe 'validator syntax' do
      it 'should allow strings as validator names' do
        expect(validate({ v: 'test' }, { v: 'string' }).valid?).to eq true
      end

      it 'should allow symbols as validator names' do
        expect(validate({ v: 'test' }, { v: :string }).valid?).to eq true
      end
    end

    describe 'full validations' do
      let(:empty_hash) {{}}

      let(:simple_hash) {{
          foo: 1,
          bar: 'baz'
        }}

      let(:invalid_simple_hash) {{
          foo: 1,
          bar: 2
        }}

      let(:complex_hash) {{
          foo: 1,
          bar: 'baz',
          user: {
            first_name: 'James',
            last_name:  'Brooks',
            age:        27,
            likes:      [ 'Ruby', 'Kendo', 'Board Games' ]
          }
        }}

      let(:invalid_complex_hash) {{
          foo: 1,
          bar: 2,
          user: {
            first_name: 'James',
            last_name:  'Brooks',
            likes:      'Ruby, Kendo, Board Games'
          }
        }}

      describe 'no validations' do
        let(:validations) {{}}

        it 'should validate an empty hash' do
          v = validate(empty_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should validate a simple hash' do
          v = validate(simple_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should validate a simple hash 2' do
          v = validate(invalid_simple_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should validate a complex hash' do
          v = validate(complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should validate a complex hash 2' do
          v = validate(invalid_complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end
      end

      describe 'simple validations' do
        let(:validations) {{ foo: 'numeric', bar: 'string' }}

        it 'should not validate an empty hash (stating missing with required)' do
          v = validate(empty_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ foo: 'numeric required', bar: 'string required' })
        end

        it 'should validate a simple hash' do
          v = validate(simple_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should not validate a simple hash 2' do
          v = validate(invalid_simple_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ bar: 'string required' })
        end

        it 'should validate a complex hash' do
          v = validate(complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should not validate a complex hash 2' do
          v = validate(invalid_complex_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ bar: 'string required' })
        end
      end

      describe 'nested validations' do
        let(:validations) {{
          foo: 'numeric',
          bar: 'string',
          user: {
            first_name: 'string',
            last_name:  /^(Brooks|Smith)$/,
            age:        'required',
            likes:      'array'
          }
        }}

        it 'should validate a complex hash' do
          v = validate(complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should not validate a complex hash 2' do
          v = validate(invalid_complex_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ bar: 'string required', user: { age: 'is required', likes: 'array required' } })
        end
      end

      describe 'optional validations' do
        let(:validations) {{ foo: 'numeric', bar: HashValidator.optional('string') }}

        it 'should validate a complex hash' do
          v = validate(complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should not validate a complex hash 2' do
          v = validate(invalid_complex_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ bar: 'string required' })
        end
      end

      describe 'many validations' do
        let(:validations) {{ foo: 'numeric', bar: 'string', user: { first_name: 'string', likes: HashValidator.many('string') } }}

        it 'should validate a complex hash' do
          v = validate(complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should not validate a complex hash 2' do
          v = validate(invalid_complex_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ bar: 'string required', user: { likes: 'enumerable required' } })
        end
      end

      describe 'multiple validations' do
        let(:validations) {{ foo: 'numeric', user: { age: HashValidator.multiple('numeric', 1..100) } }}

        it 'should validate a complex hash' do
          v = validate(complex_hash, validations)
          expect(v.valid?).to eq true
          expect(v.errors).to be_empty
        end

        it 'should not validate a complex hash 2' do
          v = validate(invalid_complex_hash, validations)
          expect(v.valid?).to eq false
          expect(v.errors).to eq({ user: { age: 'numeric required, value from list required' } })
        end
      end
    end
  end
end

describe 'Strict Validation' do
  let(:simple_hash) { { foo: 'bar', bar: 'foo' } }

  let(:complex_hash) {{
      foo: 1,
      user: {
        first_name: 'James',
        last_name:  'Brooks',
        age:        27,
        likes:      [ 'Ruby', 'Kendo', 'Board Games' ]
      }
    }}

  let(:validations) { { foo: 'string' } }

  let(:complex_validations) {{
      foo: 'integer',
      user: {
        first_name: 'string', age: 'integer'
      }
    }}

  it 'reports which keys are not expected for a simple hash' do
    v = validate(simple_hash, validations, true)
    expect(v.valid?).to eq false
    expect(v.errors).to eq({ bar: 'key not expected' })
  end

  it 'reports which keys are not expected for a complex hash' do
    v = validate(complex_hash, complex_validations, true)
    expect(v.valid?).to eq false
    expect(v.errors).to eq(user: { last_name: 'key not expected', likes: 'key not expected' })
  end

end
