require './lib/macaco/multipart'

module Macaco
  class Api

    def self.post(args = {})
      resp = http_response(args[:request], args[:api_root])
      JSON.parse(resp.body)
    end

    private

    def self.http_response(request, api_root)
      http_instance(api_root).start { |http| http.request(request) }
    end

    def self.http_instance(api_root)
      http = Net::HTTP.new(api_root, 443)
      http.use_ssl = true
      http
    end

  end
end
