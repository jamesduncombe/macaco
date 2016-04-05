require 'spec_helper'

describe Macaco::Mailgun do

  before do
    Macaco.configure do |config|
      config.api_key = ENV['MAILGUN_API_KEY']
    end
  end

  let(:mail) do
    Macaco::Mailgun.new do
      to      [{ email: 'test@sink.sendgrid.net', name: 'Test'}, { email: 'test2@sink.sendgrid.net', name: 'Test2' }]
      from    'test2@sink.sendgrid.net'
      subject 'Subject for my email'
      body_text 'test'
      mailgun_domain ENV.fetch('MAILGUN_API_DOMAIN')
    end
  end

  describe '#docs' do
    it 'returns back the address for the documentation for the REAL API method' do
      Macaco::Mailgun.new.docs.must_equal 'https://documentation.mailgun.com/api-sending.html#sending'
    end
  end

  describe '#api_root' do
    it { Macaco::Mailgun.new.api_root.must_equal 'api.mailgun.net' }
  end

  describe '#api_path' do
    it { mail.api_path.must_equal "/v3/#{ENV.fetch('MAILGUN_API_DOMAIN')}/messages" }
  end

  describe '#to' do
    it 'needs to handle multiple recipients' do
      m = Macaco::Mailgun.new do
        to [ 'test1@sink.sendgrid.net', 'test2@sink.sendgrid.net' ]
        to 'test3@sink.sendgrid.net'
      end
      m.to.must_equal([
        'test1@sink.sendgrid.net',
        'test2@sink.sendgrid.net',
        'test3@sink.sendgrid.net'
      ])
    end
  end

  describe '#to_hash' do
    subject { mail.to_hash }
    it { subject.must_be_kind_of Hash }
  end

  describe '#to_json' do
    it 'converts the mandrill hash into a JSON string' do
      mail.to_json.must_be_kind_of String
    end
  end

  describe '#send' do
    subject do
      VCR.use_cassette('send_mailgun') do
        mail.send
      end
    end
    it { subject.must_be_kind_of Hash }
    it { subject['message'].must_equal 'Queued. Thank you.' }
  end
end
