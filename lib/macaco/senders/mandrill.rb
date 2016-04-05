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

    def headers
      {
        "Content-Type" => content_type
      }
    end

    def to_hash
      {
        message: {
          from_email: @from,
          to:         @to,
          subject:    @subject,
          html:       @body_html,
          text:       @body_text
        }
      }
    end

    def to(*val)
      return @to if val.flatten.compact.empty?

      @to += val.flatten.map do |eml|
        if eml.is_a? Hash
          {
            email: fetch_email(eml),
            name: eml.fetch(:name) { nil }
          }
        else
          { email: eml }
        end
      end
    end

    def send
      Macaco::Api.post({
        api_root: api_root,
        request: request
      })
    end

    private

    def data
      to_hash.merge({ key: api_key })
    end

    def request
      req = Net::HTTP::Post.new(api_path, headers)
      req.body = data.to_json
      req
    end

  end
end
