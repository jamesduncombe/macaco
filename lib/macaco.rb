require 'net/http'
require 'json'
require 'open-uri'

require 'macaco/version'
require 'macaco/multipart'
require 'macaco/curlable'
require 'macaco/api'
require 'macaco/senders/sender'
require 'macaco/senders/mandrill'
require 'macaco/senders/sendgrid'
require 'macaco/senders/mailgun'

module Macaco
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config)
  end

  class Configuration
    attr_accessor :api_key, :debug
  end
end
