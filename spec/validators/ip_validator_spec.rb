require 'spec_helper'

describe HashValidator::Validator::IpValidator do
  let(:validator) { HashValidator::Validator::IpValidator.new }

  context 'valid IP addresses' do
    it 'validates IPv4 addresses' do
      errors = {}
      validator.validate('key', '192.168.1.1', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv4 localhost' do
      errors = {}
      validator.validate('key', '127.0.0.1', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv4 zero address' do
      errors = {}
      validator.validate('key', '0.0.0.0', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv4 broadcast address' do
      errors = {}
      validator.validate('key', '255.255.255.255', {}, errors)
      expect(errors).to be_empty
    end

    it 'validates IPv6 addresses' do
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

    it 'validates IPv4-mapped IPv6 addresses' do
      errors = {}
      validator.validate('key', '::ffff:192.168.1.1', {}, errors)
      expect(errors).to be_empty
    end
  end

  context 'invalid IP addresses' do
    it 'rejects non-string values' do
      errors = {}
      validator.validate('key', 123, {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects nil values' do
      errors = {}
      validator.validate('key', nil, {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects malformed IPv4 addresses' do
      errors = {}
      validator.validate('key', '256.1.1.1', {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects malformed IPv6 addresses' do
      errors = {}
      validator.validate('key', '2001:db8:85a3::8a2e::7334', {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects non-IP strings' do
      errors = {}
      validator.validate('key', 'not an ip', {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects empty strings' do
      errors = {}
      validator.validate('key', '', {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects hostnames' do
      errors = {}
      validator.validate('key', 'example.com', {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end

    it 'rejects URLs' do
      errors = {}
      validator.validate('key', 'http://192.168.1.1', {}, errors)
      expect(errors['key']).to eq('is not a valid IP address')
    end
  end
end