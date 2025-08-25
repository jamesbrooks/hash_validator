# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hash_validator/version"

Gem::Specification.new do |spec|
  spec.name          = "hash_validator"
  spec.version       = HashValidator::VERSION
  spec.authors       = ["James Brooks"]
  spec.email         = ["james@gooddogdesign.com"]
  spec.description   = "Ruby library to validate hashes (Hash) against user-defined requirements"
  spec.summary       = "Ruby library to validate hashes (Hash) against user-defined requirements"
  spec.homepage      = "https://github.com/JamesBrooks/hash_validator"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0.0"
  spec.files                 = `git ls-files`.split($/)
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "rubocop-performance", "~> 1.25"
  spec.add_development_dependency "rubocop-rspec", "~> 3.6"
end
