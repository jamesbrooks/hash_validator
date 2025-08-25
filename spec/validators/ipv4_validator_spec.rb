# frozen_string_literal: true

require "spec_helper"

describe HashValidator::Validator::Ipv4Validator do
  let(:validator) { HashValidator::Validator::Ipv4Validator.new }

  context "valid IPv4 addresses" do
    it "validates standard IPv4 addresses" do
      errors = {}
      validator.validate("key", "192.168.1.1", {}, errors)
      expect(errors).to be_empty
    end

    it "validates localhost" do
      errors = {}
      validator.validate("key", "127.0.0.1", {}, errors)
      expect(errors).to be_empty
    end

    it "validates zero address" do
      errors = {}
      validator.validate("key", "0.0.0.0", {}, errors)
      expect(errors).to be_empty
    end

    it "validates broadcast address" do
      errors = {}
      validator.validate("key", "255.255.255.255", {}, errors)
      expect(errors).to be_empty
    end

    it "validates private network addresses" do
      errors = {}
      validator.validate("key", "10.0.0.1", {}, errors)
      expect(errors).to be_empty
    end

    it "validates Class B private addresses" do
      errors = {}
      validator.validate("key", "172.16.0.1", {}, errors)
      expect(errors).to be_empty
    end
  end

  context "invalid IPv4 addresses" do
    it "rejects non-string values" do
      errors = {}
      validator.validate("key", 123, {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects nil values" do
      errors = {}
      validator.validate("key", nil, {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects octets over 255" do
      errors = {}
      validator.validate("key", "256.1.1.1", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects too few octets" do
      errors = {}
      validator.validate("key", "192.168.1", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects too many octets" do
      errors = {}
      validator.validate("key", "192.168.1.1.1", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects IPv6 addresses" do
      errors = {}
      validator.validate("key", "2001:db8::1", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects malformed addresses" do
      errors = {}
      validator.validate("key", "192.168.1.", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects empty strings" do
      errors = {}
      validator.validate("key", "", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end

    it "rejects non-numeric octets" do
      errors = {}
      validator.validate("key", "192.168.a.1", {}, errors)
      expect(errors["key"]).to eq("is not a valid IPv4 address")
    end
  end
end
