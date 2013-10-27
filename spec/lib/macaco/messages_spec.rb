require 'spec_helper'

describe Macaco::Messages do

  describe '#send_message' do
    subject do
      data = {
        message: {
          text: 'Boom boom',
          html: '''
            <h1>My email title</h1>
            <p>My email body</p>
            <small>Monkey Corp Ltd</small>
          ''',
          subject: 'Test subject',
          from_email: 'james@jamesduncombe.com',
          to: [{ email: 'james@jamesduncombe.com' }]
        }
      }
      Macaco.configure do |config|
        config.api_key = ENV['MANDRILL_API_KEY']
      end
      VCR.use_cassette('send_message') do
        Macaco::Messages.send_message(data)
      end
    end
    it { subject.must_be_kind_of Array }
    it { subject.first['status'].must_equal 'sent' }
  end
end
