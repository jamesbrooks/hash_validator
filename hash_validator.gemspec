# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_validator"
  spec.version       = HashValidator::VERSION
  spec.authors       = ["James Brooks"]
  spec.email         = ["james@gooddogdesign.com"]
  spec.description   = "Ruby library to validate hashes (Hash) against user-defined requirements"
  spec.summary       = "Ruby library to validate hashes (Hash) against user-defined requirements"
  spec.homepage      = "https://github.com/JamesBrooks/hash_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.13.0'
  spec.add_development_dependency 'coveralls'
end
