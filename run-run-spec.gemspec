# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'run_run_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "run-run-spec"
  spec.version       = RunRunSpec::VERSION
  spec.authors       = ["pekepek"]
  spec.email         = ["ishihata@33i.co.jp"]

  spec.summary       = %q{the stick man will run for the safety of your code}
  spec.description   = ''
  spec.homepage      = "https://github.com/pekepek/run-run-spec"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "rspec"
end
