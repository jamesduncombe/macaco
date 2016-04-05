require 'base64'

module Macaco
  class Mailgun < Sender

    def initialize(*)
      @mailgun_domain = nil
      super
    end

    def docs
      'https://documentation.mailgun.com/api-sending.html#sending'
    end

    def api_root
      'api.mailgun.net'
    end

    def api_path
      "/v3/#{mailgun_domain}/messages"
    end

    def content_type
      'multipart/form-data'
    end

    def headers
      {
        "Content-Type" => content_type,
        "Authorization" => "Basic #{Base64.encode64('api:'+api_key).strip}"
      }
    end

    def to(*val)
      return @to if val.flatten.compact.empty?

      @to += val.flatten.each_with_object([]) do |eml, accm|
        accm << if eml.is_a? Hash
                  email = fetch_email(eml)
                  email = "#{eml.fetch(:name)} <#{email}>" if eml.has_key? :name
                  email
                else
                  eml
                end
      end
    end

    def from(val = nil)
      return @from if val.nil?
      if val.is_a? Hash
        @from = fetch_email(val)
      else
        @from = val
      end
    end

    def attachment(*val)
      return @attachment if val.flatten.compact.empty?
      @attachment += val.flatten.map { |f| file_handler(f) }
    end
    alias_method :attachments, :attachment

    def mailgun_domain(val = nil)
      return @mailgun_domain if val.nil?
      @mailgun_domain = val
    end

    def to_hash
      {
        from:     @from,
        to:       @to,
        subject:  @subject,
        html:     @body_html,
        text:     @body_text,
        attachment: @attachment
      }
    end

    def send
      Macaco::Api.post({
        api_root: api_root,
        request: request
      })
    end

    private

    def request
      multipart = Macaco::Multipart.new(self)
      new_headers = headers.merge(multipart.headers)
      req = Net::HTTP::Post.new(api_path, new_headers)
      req.body_stream = multipart
      req
    end

    def file_handler(f)
      return f if f.respond_to? :read
      File.open(File.expand_path(f), 'r')
    rescue Errno::ENOENT
      raise ArgumentError, "Macaco can't open file: #{f}"
    end

  end
end
