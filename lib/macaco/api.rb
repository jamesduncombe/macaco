module Macaco
  class Api

    def self.post(args = {})
      request = request_instance(args)
      request.body = args[:data]

      JSON.parse(http_response(request, args).body)
    end

    private

    def self.http_response(request, args)
      http_instance(args).start { |http| http.request(request) }
    end

    def self.request_instance(args)
      headers = args.fetch(:headers)

      puts args[:mail].to_curl if Macaco.config.debug

      Net::HTTP::Post.new(args[:mail].api_path, headers)
    end

    def self.http_instance(args)
      http = Net::HTTP.new(args[:mail].api_root, 443)
      http.use_ssl = true
      http
    end

  end
end
