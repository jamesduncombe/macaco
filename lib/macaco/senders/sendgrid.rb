module Macaco
  class Sendgrid < Sender

    def docs
      'http://sendgrid.com/docs/API_Reference/Web_API/mail.html'
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

    def to_hash
      {
        from: @from,
        to: @to,
        subject: @subject,
        html: @body_html,
        text: @body_text
      }
    end

    def to(val = nil)
      return @to unless val
      @to << val
    end

    def send
      data = to_hash.merge!({ api_key: api_key, api_user: api_user })
      Macaco::Api.post({ mail: self, data: convert_data_params(data) })
    end

    private

    def convert_data_params(data)
      addr = Addressable::URI.new
      addr.query_values = data
      addr.query
    end

    def api_key
      Macaco.config.api_key || ENV['MACACO_API_KEY']
    end

    def api_user
      Macaco.config.api_user || ENV['MACACO_USER']
    end

  end
end
