require 'uri'
module Macaco
  class Curlable

    attr_reader :headers, :api_root, :api_path, :extras, :data

    def initialize(args)
      @headers = args.fetch(:headers)
      @api_root = args.fetch(:api_root)
      @api_path = args.fetch(:api_path)
      @data = args.fetch(:data) { {} }
      @extras = args.fetch(:extras) { nil }
      @content_type = @headers.fetch('Content-Type') { raise 'Must set Content-Type header' }
    end

    def to_curl
      type = @content_type.split('/').last.gsub('-', '_')
      send(type.to_sym)
    end

    def json
      "#{base} -d '#{data.to_json}'"
    end

    def x_www_form_urlencoded
      d = data.each_with_object([]) do |(k,v),accm|
        accm << "-d #{k}=\"#{v}\""
      end.join(" \\\n")
      "#{base} #{d}"
    end

    def form_data
      fields = data.each_with_object([]) do |(k,v), accm|
        if v.is_a? Array
          v.map { |a| [k,a] }.map { |s| accm << s }
        else
          accm << [k,v]
        end
      end
      d = fields.each_with_object([]) do |(k,v),accm|
        value = if v.respond_to? :read
                  "@#{v.path}"
                else
                  v
                end
        accm << "-F #{k}=\"#{value}\""
      end.join(" \\\n")
      "#{base} #{d}"
    end

    private

    def base
      "curl #{extras} -X POST https://#{api_root}#{api_path} \\\n #{formatted_headers} \\\n "
    end

    def formatted_headers
      headers.each_with_object([]) do |(k,v), accm|
        accm << "-H '#{k}: #{v}'"
      end.join ' '
    end

  end
end