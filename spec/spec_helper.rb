require 'rubygems'
require 'bundler'
Bundler.require
require 'minitest/autorun'
require 'minitest/pride'

require 'vcr'
require 'macaco'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end
