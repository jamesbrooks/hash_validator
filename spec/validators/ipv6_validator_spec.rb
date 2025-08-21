require 'spec_helper'

describe HashValidator::Validator::Ipv6Validator do
  let(:validator) { HashValidator::Validator::Ipv6Validator.new }

  context 'valid IPv6 addresses' do
    it 'validates full IPv6 addresses' do
      errors = {}
      validator.validate('key', '2001:0db8:85a3:0000:0000:8a2e:0370:7334', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates compressed IPv6 addresses' do
      errors = {}
      validator.validate('key', '2001:db8:85a3::8a2e:370:7334', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv6 localhost' do
      errors = {}
      validator.validate('key', '::1', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv6 zero address' do
      errors = {}
      validator.validate('key', '::', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv6 with leading zeros' do
      errors = {}
      validator.validate('key', '2001:0db8::0001', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv6 with mixed case' do
      errors = {}
      validator.validate('key', '2001:DB8::1', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv4-mapped IPv6 addresses' do
      errors = {}
      validator.validate('key', '::ffff:192.168.1.1', {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid IPv6 addresses' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects IPv4 addresses' do
      errors = {}
      validator.validate('key', '192.168.1.1', {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects malformed IPv6 addresses' do
      errors = {}
      validator.validate('key', '2001:db8:85a3::8a2e::7334', {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects too many groups' do
      errors = {}
      validator.validate('key', '2001:0db8:85a3:0000:0000:8a2e:0370:7334:extra', {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects invalid characters' do
      errors = {}
      validator.validate('key', '2001:db8:85a3::8a2g:370:7334', {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end

    it 'rejects incomplete addresses' do
      errors = {}
      validator.validate('key', '2001:db8:', {}, errors)
      expect(errors['key']).to eq('is not a valid IPv6 address')
    end
  end
end