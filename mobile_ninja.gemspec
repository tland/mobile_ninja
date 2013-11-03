# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mobile_ninja/version'

Gem::Specification.new do |spec|
  spec.name          = "mobile_ninja"
  spec.version       = MobileNinja::VERSION
  spec.authors       = ["Kevin Wang"]
  spec.email         = ["kwanghz@gmail.com"]
  spec.description   = %q{A rails gem that makes detecting mobile devices easy}
  spec.summary       = %q{A rails gem that allows for detecting mobile devices that access the your Rails application}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~>3.2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
end
