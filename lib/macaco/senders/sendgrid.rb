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

    def to(val = nil)
      return @to if val.nil?
      return to([val]) unless val.is_a? Array

      @to += val.each_with_object([]) do |eml, accm|
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

    def toname(val = nil)
      return @toname if val.nil?
      return toname([val]) unless val.is_a? Array
      @toname += val
    end

    def attachment(val = nil)
      return @attachment if val.nil?
      if val.is_a? Array
        @attachment += val.map do |f|
          file_handler(val)
        end
      else
        @attachment << file_handler(val)
      end
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
        attachment: @attachment
      }
    end

    def send
      Macaco::Api.post({
        mail: self,
        data: convert_data_params(data),
        headers: headers
      })
    end

    private

    def convert_data_params(data)
      return URI.encode_www_form(data) if @attachment.nil?
      data
    end

    def file_handler(f)
      return f if f.respond_to? :read
      File.open(File.expand_path(f), 'r')
    rescue Errno::ENOENT
      raise ArgumentError, "Macaco can't open file: #{f}"
    end

  end
end
