require 'spec_helper'

describe Macaco::Sendgrid do

  # For test addresses
  # SEE: https://support.sendgrid.com/hc/en-us/articles/203891358-Does-Sendgrid-offer-a-sandbox-or-test-environment-

  before do
    Macaco.configure do |config|
      config.api_key  = ENV['SENDGRID_API_KEY']
    end
  end

  let(:mail) do
    Macaco::Sendgrid.new do
      to        [{ email: 'test1@sink.sendgrid.net', name: 'to1' }, 'test2@sink.sendgrid.net']
      to        [{ email: 'test3@sink.sendgrid.net', name: 'to2' }]
      from({email: 'test@sink.sendgrid.net', name: 'Sink'})
      subject   'Subject for my email'
      body_html '<h1>This is a header for the HTML version</h1>'
      body_text 'This is the Text version'
      attachment './README.md'
    end
  end

  let(:mail_with_no_attachments) do
    Macaco::Sendgrid.new do
      to      'test@sink.sendgrid.net'
      from    'test@sink.sendgrid.net'
      subject 'test'
      text    'test'
    end
  end

  describe '.new' do
    subject { Macaco::Sendgrid.new({ to: { email: 'test1@sink.sendgrid.net'} }) }
    it { subject.to.must_equal ['test1@sink.sendgrid.net'] }
  end

  describe '#docs' do
    it 'returns back the address for the documentation for the REAL API method' do
      Macaco::Sendgrid.new.docs.must_equal 'https://sendgrid.com/docs/API_Reference/Web_API/mail.html#-send'
    end
  end

  describe '#attachment' do
    it 'handles invalid files' do
      proc { mail.attachment('asdasd') }.must_raise ArgumentError
    end
    it 'handles multiple attachments' do
      mail.attachment './Gemfile'
      mail.attachment.map { |file| File.basename(file) }.must_equal %w(README.md Gemfile)
    end
    it 'handles plural of attachment' do
      mail.attachments './Gemfile'
    end
  end

  describe '#to' do
    it 'needs to handle multiple recipients' do
      mail.to.must_equal [ 'test1@sink.sendgrid.net', 'test2@sink.sendgrid.net', 'test3@sink.sendgrid.net' ]
    end
  end

  describe '#toname' do
    subject { mail.toname }
    it { subject.count.must_equal 3 }
  end

  describe '#from' do
    subject { mail.from }
    it { subject.must_equal 'test@sink.sendgrid.net' }
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
    it 'converts the Sendgrid hash into a JSON string' do
      mail.to_json.must_be_kind_of String
    end
  end

  describe '#to_curl' do
    it 'converts the Sendgrid request into a cURL request' do
      mail.to_curl.must_be_kind_of String
    end
  end

  describe '#content_type' do
    it 'with attachments sets content_type to multipart/form-data' do
      mail.content_type.must_equal 'multipart/form-data'
    end
    it 'application/x-www-form-urlencoded as content_type if there are no attachments' do
      mail_with_no_attachments.content_type.must_equal 'application/x-www-form-urlencoded'
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
