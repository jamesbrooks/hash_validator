# frozen_string_literal: true

require "spec_helper"

describe HashValidator::Validator::AlphaValidator do
  let(:validator) { HashValidator::Validator::AlphaValidator.new }

  context "valid alpha strings" do
    it "validates lowercase letters" do
      errors = {}
      validator.validate("key", "abc", {}, errors)
      expect(errors).to be_empty
    end

    it "validates uppercase letters" do
      errors = {}
      validator.validate("key", "ABC", {}, errors)
      expect(errors).to be_empty
    end

    it "validates mixed case letters" do
      errors = {}
      validator.validate("key", "AbC", {}, errors)
      expect(errors).to be_empty
    end

    it "validates single letter" do
      errors = {}
      validator.validate("key", "a", {}, errors)
      expect(errors).to be_empty
    end

    it "validates long strings" do
      errors = {}
      validator.validate("key", "HelloWorld", {}, errors)
      expect(errors).to be_empty
    end
  end

  context "invalid alpha strings" do
    it "rejects non-string values" do
      errors = {}
      validator.validate("key", 123, {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects nil values" do
      errors = {}
      validator.validate("key", nil, {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects strings with numbers" do
      errors = {}
      validator.validate("key", "abc123", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects strings with spaces" do
      errors = {}
      validator.validate("key", "abc def", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects strings with special characters" do
      errors = {}
      validator.validate("key", "abc!", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects strings with hyphens" do
      errors = {}
      validator.validate("key", "abc-def", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects strings with underscores" do
      errors = {}
      validator.validate("key", "abc_def", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects empty strings" do
      errors = {}
      validator.validate("key", "", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end

    it "rejects strings with periods" do
      errors = {}
      validator.validate("key", "abc.def", {}, errors)
      expect(errors["key"]).to eq("must contain only letters")
    end
  end
end
