require './lib/macaco/multipart'

module Macaco
  class Api

    def self.post(args = {})
      # TODO: Remove this special case
      if args[:mail].attachment.empty? && !args[:mail].content_type == 'multipart/form-data'
        request = request_instance(args)
        request.body = args[:data]
      else
        m = Macaco::Multipart.new(args[:mail])
        args[:headers] = args[:headers].merge(m.headers)
        request = request_instance(args)
        request.body_stream = m
      end

      resp = http_response(request, args)
      JSON.parse(resp.body)
    end

    private

    def self.request_instance(args)
      Net::HTTP::Post.new(args[:mail].api_path, args.fetch(:headers))
    end

    def self.http_response(request, args)
      http_instance(args).start { |http| http.request(request) }
    end

    def self.http_instance(args)
      http = Net::HTTP.new(args[:mail].api_root, 443)
      http.use_ssl = true
      http
    end

  end
end
