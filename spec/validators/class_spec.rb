require 'spec_helper'

describe 'Class validator' do
  let(:errors) { Hash.new }

  {
    Array => {
      valid:   [ [], [1], ['foo'], [1,['foo'],Time.now] ],
      invalid: [ nil, '', 123, '123', Time.now, '[1]' ]
    },
    Complex => {
      valid:   [ Complex(1), Complex(2, 3), Complex('2/3+3/4i'), 0.3.to_c ],
      invalid: [ nil, '', 123, '123', Time.now, '[1]', [1], '2/3+3/4i', Rational(2, 3) ]
    },
    Float => {
      valid:   [ 0.0, 1.1, 1.23, Float::INFINITY, Float::EPSILON ],
      invalid: [ nil, '', 0, 123, '123', Time.now, '[1]', '2013-03-04' ]
    },
    Integer => {
      valid:   [ 0, -1000000, 1000000 ],
      invalid: [ nil, '', 1.1, '123', Time.now, '[1]', '2013-03-04' ]
    },
    Numeric => {
      valid:   [ 0, 123, 123.45 ],
      invalid: [ nil, '', '123', Time.now ]
    },
    Range => {
      valid:   [ 0..10, 'a'..'z', 5..0 ],
      invalid: [ nil, '', '123', Time.now ]
    },
    Rational => {
      valid:   [ Rational(1), Rational(2, 3), 3.to_r ],
      invalid: [ nil, '', 123, '123', Time.now, '[1]', [1], Complex(2, 3) ]
    },
    Regexp => {
      valid:   [ /[a-z]+/, //, //i, Regexp.new('.*') ],
      invalid: [ nil, '', 123, '123', Time.now, '.*' ]
    },
    String => {
      valid:   [ '', 'Hello World', '12345' ],
      invalid: [ nil, 12345, Time.now ]
    },
    Symbol => {
      valid:   [ :foo, :'', 'bar'.to_sym ],
      invalid: [ nil, '', 1.1, '123', Time.now, '[1]', '2013-03-04' ]
    },
    Time => {
      valid:   [ Time.now ],
      invalid: [ nil, '', 123, '123', "#{Time.now}" ]
    }
  }.each do |type, data|
    describe type do
      data[:valid].each do |value|
        it "validates '#{value}' successful" do
          validator = HashValidator.validate({ v: value }, { v: type })

          expect(validator.valid?).to eq true
          expect(validator.errors).to be_empty
        end
      end

      data[:invalid].each do |value|
        it "validates '#{value}' with failure" do
          validator = HashValidator.validate({ v: value }, { v: type })

          expect(validator.valid?).to eq false
          expect(validator.errors).to eq({ v: "#{type} required" })
        end
      end
    end
  end
end
