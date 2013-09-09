# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adm/version'

Gem::Specification.new do |spec|
  spec.name          = "adm"
  spec.version       = ADM::VERSION
  spec.authors       = ["Tal Atlas"]
  spec.email         = ["me@tal.by"]
  spec.description   = %q{Amazon Device Messaging Gem}
  spec.summary       = %q{Send messages via the Amazon Device Messaging (ADM) service.}
  spec.homepage      = "https://github.com/tal/adm"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.3.5"
  spec.add_development_dependency "rake"

  spec.add_dependency 'typhoeus'
  spec.add_dependency 'multi_json'
end
