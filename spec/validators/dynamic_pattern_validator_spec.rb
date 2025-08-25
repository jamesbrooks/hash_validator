# frozen_string_literal: true

require "spec_helper"

describe HashValidator::Validator::DynamicPatternValidator do
  describe "Pattern-based validator" do
    let(:odd_pattern_validator) do
      HashValidator::Validator::DynamicPatternValidator.new(
        "odd_pattern",
        /\A\d*[13579]\z/,
        "is not an odd number"
      )
    end

    let(:postal_code_validator) do
      HashValidator::Validator::DynamicPatternValidator.new(
        "us_postal",
        /\A\d{5}(-\d{4})?\z/,
        "is not a valid US postal code"
      )
    end

    let(:errors) { Hash.new }

    describe "#initialize" do
      it "requires a valid regular expression" do
        expect {
          HashValidator::Validator::DynamicPatternValidator.new("test", "not_a_regex")
        }.to raise_error(ArgumentError, "Pattern must be a regular expression")
      end

      it "accepts a custom error message" do
        validator = HashValidator::Validator::DynamicPatternValidator.new(
          "test",
          /test/,
          "custom error"
        )
        expect(validator.error_message).to eq("custom error")
      end

      it "uses default error message when none provided" do
        validator = HashValidator::Validator::DynamicPatternValidator.new("test", /test/)
        expect(validator.error_message).to eq("test required")
      end
    end

    describe "#should_validate?" do
      it "validates the correct name" do
        expect(odd_pattern_validator.should_validate?("odd_pattern")).to eq true
      end

      it "does not validate other names" do
        expect(odd_pattern_validator.should_validate?("even_pattern")).to eq false
        expect(odd_pattern_validator.should_validate?("string")).to eq false
      end
    end

    describe "#validate" do
      context "with odd number pattern" do
        it "validates odd numbers correctly" do
          odd_pattern_validator.validate(:key, "1", {}, errors)
          expect(errors).to be_empty

          errors.clear
          odd_pattern_validator.validate(:key, "13", {}, errors)
          expect(errors).to be_empty

          errors.clear
          odd_pattern_validator.validate(:key, "999", {}, errors)
          expect(errors).to be_empty
        end

        it "rejects even numbers" do
          odd_pattern_validator.validate(:key, "2", {}, errors)
          expect(errors).to eq({ key: "is not an odd number" })

          errors.clear
          odd_pattern_validator.validate(:key, "100", {}, errors)
          expect(errors).to eq({ key: "is not an odd number" })
        end

        it "rejects non-numeric strings" do
          odd_pattern_validator.validate(:key, "abc", {}, errors)
          expect(errors).to eq({ key: "is not an odd number" })
        end

        it "converts non-string values to strings" do
          odd_pattern_validator.validate(:key, 13, {}, errors)
          expect(errors).to be_empty

          errors.clear
          odd_pattern_validator.validate(:key, 14, {}, errors)
          expect(errors).to eq({ key: "is not an odd number" })
        end
      end

      context "with postal code pattern" do
        it "validates correct postal codes" do
          postal_code_validator.validate(:key, "12345", {}, errors)
          expect(errors).to be_empty

          errors.clear
          postal_code_validator.validate(:key, "12345-6789", {}, errors)
          expect(errors).to be_empty
        end

        it "rejects invalid postal codes" do
          postal_code_validator.validate(:key, "1234", {}, errors)
          expect(errors).to eq({ key: "is not a valid US postal code" })

          errors.clear
          postal_code_validator.validate(:key, "12345-678", {}, errors)
          expect(errors).to eq({ key: "is not a valid US postal code" })

          errors.clear
          postal_code_validator.validate(:key, "ABCDE", {}, errors)
          expect(errors).to eq({ key: "is not a valid US postal code" })
        end
      end
    end

    describe "Integration with HashValidator.add_validator" do
      before do
        HashValidator.add_validator("phone_number",
          pattern: /\A\d{3}-\d{3}-\d{4}\z/,
          error_message: "is not a valid phone number")
      end

      after do
        HashValidator.remove_validator("phone_number")
      end

      it "can be registered and used via add_validator" do
        validator = HashValidator.validate(
          { phone: "555-123-4567" },
          { phone: "phone_number" }
        )
        expect(validator.valid?).to eq true
        expect(validator.errors).to be_empty
      end

      it "returns errors for invalid values" do
        validator = HashValidator.validate(
          { phone: "5551234567" },
          { phone: "phone_number" }
        )
        expect(validator.valid?).to eq false
        expect(validator.errors).to eq({ phone: "is not a valid phone number" })
      end
    end
  end
end
