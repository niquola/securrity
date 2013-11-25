# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'securrity/version'

Gem::Specification.new do |spec|
  spec.name          = "securrity"
  spec.version       = Securrity::VERSION
  spec.authors       = ["niquola"]
  spec.email         = ["niquola@gmail.com"]
  spec.description   = %q{RBAC implementation for health it}
  spec.summary       = %q{RBAC implementation for health it}%
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'pg'
  spec.add_dependency 'sequel'
  spec.add_dependency 'virtus'
  spec.add_dependency 'uuid'
  spec.add_dependency 'bcrypt-ruby'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
