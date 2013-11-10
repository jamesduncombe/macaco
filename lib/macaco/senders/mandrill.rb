module Macaco
  class Mandrill < Sender

    def api_root
      'mandrillapp.com'
    end

    def api_path
      '/api/1.0/messages/send.json'
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
      data = to_hash.merge!({ key: Macaco.config.api_key })
      Macaco::Api.post({ mail: self, data: data})
    end

  end
end
