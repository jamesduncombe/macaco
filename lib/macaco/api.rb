module Macaco
  class Api

    def self.post(args = {})

      request = request_instance(args)
      request.body = args[:data].to_json

      JSON.parse(http_response(request).body)

    end

    private

      def self.http_response(request)
        http_instance.start { |http| http.request(request) }
      end

      def self.request_instance(args)
        Net::HTTP::Post.new(args[:path], initheader = { 'Content-Type' => 'application/json' })
      end

      def self.http_instance
        http = Net::HTTP.new(Macaco.config.api_root, Macaco.config.api_port)
        http.use_ssl = true
        http
      end

  end
end
