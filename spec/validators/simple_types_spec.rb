require 'spec_helper'

describe 'Simple validator types' do
  let(:errors) { Hash.new }

  # Simple types
  {
    string: {
      valid:   [ '', 'Hello World', '12345' ],
      invalid: [ nil, 12345, Time.now ]
    },
    numeric: {
      valid:   [ 0, 123, 123.45 ],
      invalid: [ nil, '', '123', Time.now ]
    },
    array: {
      valid:   [ [], [1], ['foo'], [1,['foo'],Time.now] ],
      invalid: [ nil, '', 123, '123', Time.now, '[1]' ]
    },
    time: {
      valid:   [ Time.now ],
      invalid: [ nil, '', 123, '123', "#{Time.now}" ]
    }
  }.each do |type, data|
    describe type do
      data[:valid].each do |value|
        it "validates '#{value}' successful" do
          validator = HashValidator.validate({ v: value }, { v: type.to_s })

          validator.valid?.should be_true
          validator.errors.should be_empty
        end
      end

      data[:invalid].each do |value|
        it "validates '#{value}' with failure" do
          validator = HashValidator.validate({ v: value }, { v: type.to_s })

          validator.valid?.should be_false
          validator.errors.should eq({ v: "#{type} required" })
        end
      end
    end
  end
end
