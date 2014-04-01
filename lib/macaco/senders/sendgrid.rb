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
      data = to_hash.merge!({ api_key: api_key, api_user: api_user })
      Macaco::Api.post({ mail: self, data: data })
    end

    private

    def api_key
      Macaco.config.api_key || ENV['MACACO_API_KEY']
    end

    def api_user
      Macaco.config.api_user || ENV['MACACO_USER']
    end

  end
end
