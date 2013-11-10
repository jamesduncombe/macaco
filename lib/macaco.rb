require 'net/http'
require 'json'
require 'open-uri'

require 'macaco/version'
require 'macaco/api'
require 'macaco/senders/sender'
require 'macaco/senders/mandrill'

module Macaco
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :api_key, :sender

    def initialize
      @api_key  = ENV['MACACO_API_KEY']
      @sender   = :mandrill
    end
  end
end
