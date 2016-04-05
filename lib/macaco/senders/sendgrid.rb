module Macaco
  class Sendgrid < Sender

    def initialize(*)
      @toname = []
      @fromname = nil
      super
    end

    def docs
      'https://sendgrid.com/docs/API_Reference/Web_API/mail.html#-send'
    end

    def api_root
      'api.sendgrid.com'
    end

    def api_path
      '/api/mail.send.json'
    end

    def content_type
      'application/x-www-form-urlencoded'
    end

    def headers
      {
        "Content-Type" => content_type,
        "Authorization" => "Bearer #{api_key}"
      }
    end

    def to(*val)
      return @to if val.flatten.compact.empty?

      @to += val.flatten.each_with_object([]) do |eml, accm|
        if eml.is_a? Hash
          accm << fetch_email(eml)
          toname(eml.fetch(:name) { ' ' })
        else
          accm << eml
          toname(' ')
        end
      end
    end

    def from(val = nil)
      return @from if val.nil?
      if val.is_a? Hash
        @from = fetch_email(val)
        @fromname = val.fetch(:name) { ' ' }
      else
        @from = val
      end
    end

    def toname(*val)
      return @toname if val.empty?
      @toname += val.flatten
    end

    def attachment(*val)
      return @attachment if val.flatten.compact.empty?
      @attachment += val.flatten.map { |f| file_handler(f) }
    end
    alias_method :attachments, :attachment

    def to_hash
      {
        from:     @from,
        fromname: @fromname,
        to:       @to,
        toname:   @toname,
        subject:  @subject,
        html:     @body_html,
        text:     @body_text,
        file:     @attachment
      }
    end

    private

    def request
      multipart = Macaco::Multipart.new(self)
      new_headers = headers.merge(multipart.headers)
      req = Net::HTTP::Post.new(api_path, new_headers)
      req.body_stream = multipart
      req
    end

  end
end
