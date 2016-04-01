# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'macaco/version'

Gem::Specification.new do |gem|
  gem.name          = "macaco"
  gem.version       = Macaco::VERSION
  gem.authors       = ["James Duncombe"]
  gem.email         = ["james@jamesduncombe.com"]
  gem.summary       = %q{When all you want to do is send email}
  gem.description   = %q{Tiny gem to send email using popular email providers}
  gem.homepage      = "https://github.com/jamesduncombe/macaco"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'webmock',  '~> 0'
  gem.add_development_dependency 'vcr',      '~> 3.0'
  gem.add_development_dependency 'rake',     '~> 10.1'

end
