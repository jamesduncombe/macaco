require 'spec_helper'

describe Macaco::Mandrill do

  before do
    Macaco.configure do |config|
      config.api_key = ENV['MANDRILL_API_KEY']
    end
  end

  let(:mail) do
    Macaco::Mandrill.new do
      to      'james@jamesduncombe.com'
      from    'james@jamesduncombe.com'
      subject 'Subject for my email'
      body_html '<h1>This is a header for the HTML version</h1>'
      body_text 'This is the Text version'
    end
  end

  describe '#docs' do
    it 'returns back the address for the documentation for the REAL API method' do
      Macaco::Mandrill.new.docs.must_equal 'https://mandrillapp.com/api/docs/messages.JSON.html#method-send'
    end
  end

  describe '#api_root' do
    it { Macaco::Mandrill.new.api_root.must_equal 'mandrillapp.com' }
  end

  describe '#api_path' do
    it { Macaco::Mandrill.new.api_path.must_equal '/api/1.0/messages/send.json' }
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
      VCR.use_cassette('send_mandrill') do
        mail.send
      end
    end
    it { subject.must_be_kind_of Array }
    it { subject.first['status'].must_equal 'sent' }
  end
end
