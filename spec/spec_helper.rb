# frozen_string_literal: true

require "rubygems"
require "simplecov"
require "simplecov_json_formatter"

SimpleCov.start do
  formatter SimpleCov::Formatter::JSONFormatter
  add_filter "/spec/"
end

require "hash_validator"
require "hash_validator_spec_helper"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = "random"

  config.include HashValidatorSpecHelper
end
