# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'otp/version'

Gem::Specification.new do |spec|
  spec.name          = "otp"
  spec.version       = OTP::VERSION
  spec.authors       = ["Yuuzou Gotou"]
  spec.email         = ["gotoyuzo@notwork.org"]
  spec.summary       = %q{One-Time Password Library}
  spec.description   = %q{An implementation of HOTP (RFC4226) and TOTP (RFC6238).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
