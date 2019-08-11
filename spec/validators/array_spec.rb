require 'spec_helper'

describe 'Array validator' do
  let(:validator) { HashValidator::Validator::ArrayValidator.new }
  let(:errors)    { Hash.new }

  describe '#should_validate?' do
    it 'should validate the array with first item ":array"' do
      expect(validator.should_validate?([:array])).to eq true
    end

    it 'should validate the array with empty specification' do
      expect(validator.should_validate?([:array, { }])).to eq true
    end

    it 'should validate the array with size specified to nil' do
      expect(validator.should_validate?([:array, { size: nil }])).to eq true
    end

    it 'should validate the array with non-sense specification' do
      expect(validator.should_validate?([:array, { blah_blah_blah: false }])).to eq true
    end

    it 'should not validate the empty array' do
      expect(validator.should_validate?([])).to eq false
    end

    it 'should not validate the array with nil item' do
      expect(validator.should_validate?([nil])).to eq false
    end

    it 'should not validate other names' do
      expect(validator.should_validate?('string')).to eq false
      expect(validator.should_validate?('array')).to eq false
      expect(validator.should_validate?(nil)).to eq false
    end
  end

  describe '#validate' do
    it 'should validate an empty array with true' do
      validator.validate(:key, [], [:array], errors)

      expect(errors).to be_empty
    end

    it 'should validate an empty array with nil spec' do
      validator.validate(:key, [], [:array, nil], errors)

      expect(errors).to be_empty
    end

    it 'should validate an empty array with empty spec' do
      validator.validate(:key, [], [:array, { }], errors)

      expect(errors).to be_empty
    end

    it 'should validate an empty array with size spec = nil' do
      validator.validate(:key, [], [:array, { size: nil }], errors)

      expect(errors).to be_empty
    end

    it 'should validate an empty array with size spec = 0' do
      validator.validate(:key, [], [:array, { size: 0 }], errors)

      expect(errors).to be_empty
    end

    it 'should validate an empty array with spec = 0' do
      validator.validate(:key, [], [:array, 0], errors)

      expect(errors).to be_empty
    end

    it 'should validate an empty array with spec = 0.0' do
      validator.validate(:key, [], [:array, 0.0], errors)

      expect(errors).to be_empty
    end

    it 'should validate an array of one item with spec = 1' do
      validator.validate(:key, [nil], [:array, 1], errors)

      expect(errors).to be_empty
    end

    it 'should validate an array of five items with {size: 5.0}' do
      my_array = ["one", 2, nil, ["f", "o", "u", "r"], {five: 5}]
      validator.validate(:key, my_array, [:array, {size: 5.0}], errors)

      expect(errors).to be_empty
    end

    # >>> NOT >>>

    it 'should not validate non array value' do
      validator.validate(:key, "I'm not array", [:array], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Array required' })
    end

    it 'should not validate an empty array with size spec = 1' do
      validator.validate(:key, [], [:array, { size: 1 }], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'The required size of array is 1 but is 0.' })
    end

    it 'should not validate an empty array with size spec = 1' do
      validator.validate(:key, [], [:array, { size: 1 }], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'The required size of array is 1 but is 0.' })
    end

    it 'should not validate an empty array with spec = 1' do
      validator.validate(:key, [], [:array, 1], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'The required size of array is 1 but is 0.' })
    end

    it 'should not validate an empty array with spec = "0" (string)' do
      validator.validate(:key, [], [:array, "0"], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Second item of array specification must be Hash or Numeric.' })
    end

    it 'should not validate an empty array with spec = "1" (string)' do
      validator.validate(:key, [], [:array, "1"], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Second item of array specification must be Hash or Numeric.' })
    end

    it 'should not validate an empty array with {min_size: 0} spec' do
      validator.validate(:key, [], [:array, { min_size: 0 }], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Not supported specification for array: min_size.' })
    end

    it 'should not validate an empty array with {min_size: 0, max_size: 2} spec' do
      validator.validate(:key, [], [:array, { min_size: 0, max_size: 2 }], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Not supported specification for array: max_size, min_size.' })
    end

    it 'should not validate an array of four items with {size: 3} spec' do
      validator.validate(:key, [0, 1, 2, 3], [:array, { size: 3 }], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'The required size of array is 3 but is 4.' })
    end

    it 'should not validate an array of four items with {size: 5} spec' do
      validator.validate(:key, [0, 1, 2, 3], [:array, { size: 5 }], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'The required size of array is 5 but is 4.' })
    end

    it 'should not validate an empty array with invalid specification' do
      validator.validate(:key, [], [:blah], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Wrong array specification. The array is expected as first item.' })
    end

    it 'should not validate an empty array with to large specification' do
      validator.validate(:key, [], [:array, 0, "overlaping item"], errors)

      expect(errors).not_to be_empty
      expect(errors).to eq({ key: 'Wrong size of array specification. Allowed is one or two items.' })
    end
  end
end
