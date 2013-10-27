module Macaco
  class Messages

    def self.send_message(data)

      data.merge!({ key: Macaco.config.api_key })

      request = Net::HTTP::Post.new('/api/1.0/messages/send.json',
                                    initheader = { 'Content-Type'=> 'application/json' })
      request.body = data.to_json
      http = Net::HTTP.new(Macaco.config.api_root, Macaco.config.api_port)
      http.use_ssl = true

      response = http.start do |http|
        http.request(request)
      end

      JSON.parse(response.body)

    end
  end
end
