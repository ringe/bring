# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bring/version'

Gem::Specification.new do |spec|
  spec.name          = "bring"
  spec.version       = Bring::VERSION
  spec.authors       = ["Erlend Finvåg"]
  spec.email         = ["erlend.finvag@gmail.com"]
  spec.description   = %q{A simple utility for Bring's APIs}
  spec.summary       = %q{Command line client and Ruby library for bring's APIs}
  spec.homepage      = "https://github.com/wepack/bring"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "vcr"

  spec.add_runtime_dependency "thor"

  spec.add_dependency "faraday", "~> 0.8.0"
  spec.add_dependency "faraday_middleware"

  if RUBY_VERSION.start_with?('1.8')
    spec.add_dependency "json"
    spec.add_dependency "system_timer"
  end
end
