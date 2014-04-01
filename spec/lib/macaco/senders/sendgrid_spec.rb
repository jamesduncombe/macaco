require 'spec_helper'

describe Macaco::Sendgrid do

  before do
    Macaco.configure do |config|
      config.api_key  = ENV['SENDGRID_API_KEY']
      config.api_user = ENV['SENDGRID_USER']
    end
  end

  let(:mail) do
    Macaco::Sendgrid.new do
      to      'james@jamesduncombe.com'
      from    'james@jamesduncombe.com'
      subject 'Subject for my email'
      body_html '<h1>This is a header for the HTML version</h1>'
      body_text 'This is the Text version'
    end
  end

  describe '#docs' do
    it 'returns back the address for the documentation for the REAL API method' do
      Macaco::Sendgrid.new.docs.must_equal 'http://sendgrid.com/docs/API_Reference/Web_API/mail.html'
    end
  end

  describe '#api_root' do
    it { Macaco::Sendgrid.new.api_root.must_equal 'api.sendgrid.com' }
  end

  describe '#api_path' do
    it { Macaco::Sendgrid.new.api_path.must_equal '/api/mail.send.json' }
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
      VCR.use_cassette('send_sendgrid') do
        mail.send
      end
    end
    it { subject.must_be_kind_of Hash }
    it { subject['message'].must_equal 'success' }
  end
end
