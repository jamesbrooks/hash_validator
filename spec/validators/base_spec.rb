require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:name) { 'my_validator' }


  it 'allows a validator to be created with a valid name' do
    expect { HashValidator::Validator::Base.new(name) }.to_not raise_error
  end

  it 'does not allow a validator to be created with an invalid name' do
    expect { HashValidator::Validator::Base.new(nil) }.to raise_error(StandardError, 'Validator must be initialized with a valid name (length greater than zero)')
    expect { HashValidator::Validator::Base.new('')  }.to raise_error(StandardError, 'Validator must be initialized with a valid name (length greater than zero)')
  end

  describe '#validate' do
    let(:validator) { HashValidator::Validator::Base.new('test') }

    it 'throws an exception as base validators cant actually validate' do
      expect { validator.validate('key', 'value', {}, {}) }.to raise_error(StandardError, 'validate should not be called directly on BaseValidator')
    end
  end
end
