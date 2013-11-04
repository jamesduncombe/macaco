module Macaco
  class Mandrill

    def self.send(data)
      data.merge!({ key: Macaco.config.api_key })
      Macaco::Api.post({ path: '/api/1.0/messages/send.json', data: data })
    end

  end
end
