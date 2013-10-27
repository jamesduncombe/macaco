# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'macaco/version'

Gem::Specification.new do |gem|
  gem.name          = "macaco"
  gem.version       = Macaco::VERSION
  gem.authors       = ["James Duncombe"]
  gem.email         = ["james@jamesduncombe.com"]
  gem.description   = %q{A tiny gem to handle Mandrill's API}
  gem.summary       = %q{A tiny gem to handle Mandrill's API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
