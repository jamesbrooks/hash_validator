# frozen_string_literal: true

require "spec_helper"

describe HashValidator::Validator::Base do
  let(:name) { "my_validator" }


  it "allows a validator to be created with a valid name" do
    expect { HashValidator::Validator::Base.new(name) }.to_not raise_error
  end

  it "does not allow a validator to be created with an invalid name" do
    expect { HashValidator::Validator::Base.new(nil) }.to raise_error(StandardError, "Validator must be initialized with a valid name (length greater than zero)")
    expect { HashValidator::Validator::Base.new("")  }.to raise_error(StandardError, "Validator must be initialized with a valid name (length greater than zero)")
  end

  describe "#validate" do
    let(:validator) { HashValidator::Validator::Base.new("test") }

    it "throws an exception as base validators must implement valid? or override validate" do
      expect { validator.validate("key", "value", {}, {}) }.to raise_error(StandardError, "Validator must implement either valid? or override validate method")
    end

    it "throws an exception when valid? method has invalid arity" do
      # Create a validator with a valid? method that accepts an invalid number of arguments (3)
      invalid_arity_validator = Class.new(HashValidator::Validator::Base) do
        def valid?(value, validations, extra_param)
          true
        end
      end.new("invalid_arity")

      expect {
        invalid_arity_validator.validate("key", "value", {}, {})
      }.to raise_error(StandardError, "valid? method must accept either 1 argument (value) or 2 arguments (value, validations)")
    end
  end
end
