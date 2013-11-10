module Macaco
  class Api

    def self.post(args = {})

      request = request_instance(args)
      request.body = args[:data].to_json

      JSON.parse(http_response(request, args).body)

    end

    private

      def self.http_response(request, args)
        http_instance(args).start { |http| http.request(request) }
      end

      def self.request_instance(args)
        Net::HTTP::Post.new(args[:mail].api_path, initheader = { 'Content-Type' => 'application/json' })
      end

      def self.http_instance(args)
        http = Net::HTTP.new(args[:mail].api_root, 443)
        http.use_ssl = true
        http
      end

  end
end
