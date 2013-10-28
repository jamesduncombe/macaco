require 'net/http'
require 'json'
require 'open-uri'

require 'macaco/version'
require 'macaco/api'
require 'macaco/resources/messages'

module Macaco
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :api_key, :api_root, :api_port

    def initialize
      @api_key = ENV['MANDRILL_API_KEY']
      @api_root = 'mandrillapp.com'
      @api_port = 443
    end
  end
end
