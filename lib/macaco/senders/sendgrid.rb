module Macaco
  class Sendgrid < Sender

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

    def to_hash
      {
        from: @from,
        to: @to,
        subject: @subject,
        html: @body_html,
        text: @body_text
      }
    end

    def send
      data = to_hash
      Macaco::Api.post({
        mail: self,
        data: convert_data_params(data),
        headers: { "Authorization" => "Bearer #{api_key}" }
      })
    end

    private

    def convert_data_params(data)
      URI.encode_www_form(data)
    end

    def api_key
      Macaco.config.api_key || ENV['SENDGRID_API_KEY']
    end

  end
end
