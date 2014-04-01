# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'macaco/version'

Gem::Specification.new do |gem|
  gem.name          = "macaco"
  gem.version       = Macaco::VERSION
  gem.authors       = ["James Duncombe"]
  gem.email         = ["james@jamesduncombe.com"]
  gem.summary       = %q{Tiny wrapper around Mandrill API's send method}
  gem.description   = %q{Tiny gem to wrap Mandrill API's send method without other gem dependencies}
  gem.homepage      = "https://github.com/jamesduncombe/macaco"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'webmock', '~> 1.15.0'
  gem.add_development_dependency 'vcr',     '~> 2.9.0'
  gem.add_development_dependency 'rake'

end
