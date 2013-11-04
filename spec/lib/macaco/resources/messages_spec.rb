require 'spec_helper'

describe Macaco::Messages do

  describe '#send' do
    subject do
      VCR.use_cassette('send') do
        mail = Macaco::Message.new do
          to 'james@jamesduncombe.com'
          from 'test@jamesduncombe.com'
          subject 'This is a cool subject'
          body_html '<h1>DSFSDFSDF</h1>'
        end
        Macaco::Messages.send(mail.to_mandrill_hash)
      end
    end
    it { subject.must_be_kind_of Array }
    it { subject.first['status'].must_equal 'sent' }
  end
end
