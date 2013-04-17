require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:my_class)  { Class.new }
  let(:validator) { HashValidator::Validator::SimpleTypeValidator.new('my_class', my_class) }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the name "my_class"' do
      validator.should_validate?('my_class').should be_true
    end

    it 'should not validate other names' do
      validator.should_validate?('string').should be_false
      validator.should_validate?('array').should  be_false
      validator.should_validate?(nil).should      be_false
    end
  end

  describe '#validate' do
    it 'should validate the my_class class with true' do
      validator.validate(:key, my_class.new, {}, errors)

      errors.should be_empty
    end

    it 'should validate other classes with errrors' do
      validator.validate(:key, "foo bar", {}, errors)

      errors.should_not be_empty
      errors.should eq({ key: 'should be my_class' })
    end
  end
end
