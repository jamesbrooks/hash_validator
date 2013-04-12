require 'rubygems'
require 'bundler/setup'
require 'hash_validator'
require 'hash_validator_spec_helper'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.include HashValidatorSpecHelper
end
