require 'spec_helper'

describe HashValidator::Validator::Base do
  let(:validator) { HashValidator::Validator::Base.new }

  describe '#should_validate?' do
    it 'throws an exception' do
      expect { validator.should_validate?('name') }.to raise_error(StandardError, 'should_validate? should not be called directly on BaseValidator')
    end
  end

  describe '#validate' do
    it 'throws an exception' do
      expect { validator.validate('key', 'value', {}, {}) }.to raise_error(StandardError, 'validate should not be called directly on BaseValidator')
    end
  end
end
