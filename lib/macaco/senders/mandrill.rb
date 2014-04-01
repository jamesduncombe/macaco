module Macaco
  class Mandrill < Sender

    def docs
      'https://mandrillapp.com/api/docs/messages.JSON.html#method-send'
    end

    def api_root
      'mandrillapp.com'
    end

    def api_path
      '/api/1.0/messages/send.json'
    end

    def content_type
      'application/json'
    end

    def to_hash
      {
        message: {
          from_email: @from,
          to: @to,
          subject: @subject,
          html: @body_html,
          text: @body_text
        }
      }
    end

    def send
      data = to_hash.merge!({ key: api_key })
      Macaco::Api.post({ mail: self, data: convert_data_params(data) })
    end

    private

    def convert_data_params(data)
      data.to_hash
    end

    def api_key
      Macaco.config.api_key || ENV['MACACO_API_KEY']
    end

  end
end
