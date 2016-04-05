require 'stringio'
require 'net/http'
require 'base64'

# Heavily influenced from...
# SEE: https://github.com/rest-client/rest-client/blob/master/lib/restclient/payload.rb

module Macaco
  class Multipart

    EOL = "\r\n"

    attr_reader :mail

    def initialize(mail)
      @mail = mail
      build_stream
    end

    def build_stream
      b = "--#{boundary}"
      @stream = StringIO.new
      @stream.binmode
      @stream.write(b + EOL)

      m = mail.to_hash

      fields = m.each_with_object([]) do |(k,v), accm|
        if v.is_a? Array
          v.map { |a| [k,a] }.map { |s| accm << s }
        else
          accm << [k,v]
        end
      end

      last_index = fields.count - 1
      fields.each_with_index do |(k,v),index|
        build_part(@stream, k, v)
        @stream.write(EOL + b)
        @stream.write(EOL) unless last_index == index
      end

      @stream.write('--')
      @stream.write(EOL)
      @stream.seek(0)
    end

    def build_part(stream, k, v)
      return build_file(stream, k, v) if v.respond_to? :read
      build_value(stream, k, v)
    end

    def build_value(stream, k, v)
      stream.write("Content-Disposition: form-data; name=\"#{k}\"")
      stream.write(EOL)
      stream.write(EOL)
      v = ' ' if v.nil?
      stream.write(v)
      stream
    end

    def build_file(stream, k, v)
      stream << "Content-Disposition: form-data; name=\"files[#{File.basename(v)}]\"; filename=\"#{File.basename(v)}\"#{EOL}"
      stream << "Content-Type: #{mime_type(v)}#{EOL}"
      stream << EOL
      stream << EOL
      stream << "#{v.read}"
      stream
    ensure
      v.close
    end

    def close
      @stream.close!
    end

    def read(*args)
      @stream.read(*args)
    end

    def size
      @stream.size
    end

    def headers
      { "Content-Type" => "multipart/form-data; boundary=#{boundary}" }
    end

    private

    def boundary
      @boundary ||= "---------------------#{rand(1_000_000)}"
    end

    def mime_type(file)
      raise unless file.respond_to? :read
      res = `file --mime-type #{file.path}`
      res.split(' ').last
    rescue
      raise 'Issue getting Mime type'
    end

  end
end