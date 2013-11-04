require 'spec_helper'

describe Macaco::Message do

  let(:mail) do
    Macaco::Message.new do
      to      'to@test.com'
      from    'from@test.com'
      subject 'Subject for my email'
      body_html '<h1>This is a header for the HTML version</h1>'
      body_text 'This is the Text version'
    end
  end

  describe '#hash_attributes' do
    it 'creates a new mail record via hash' do
      m = Macaco::Message.new( from: 'from@test.com', to: 'to@test.com', subject: 'Test' )
      m.from.must_equal 'from@test.com'
    end
  end

  describe '#to_mandrill_hash' do
    subject { mail.to_mandrill_hash }
    it { subject.must_be_kind_of Hash }
  end

  describe '#to_json' do
    it 'converts the mandrill hash into a JSON string' do
      mail.to_json.must_be_kind_of String
    end
  end

  describe '#to' do
    it 'sets the recipient if theres a string provided' do
      mail.to.must_equal [ { email: 'to@test.com' } ]
    end
  end

  describe '#from' do
    it 'sets the from address' do
      mail.from.must_equal 'from@test.com'
    end
  end

  describe '#subject' do
    it 'sets the subject address' do
      mail.subject.must_equal 'Subject for my email'
    end
  end

  describe '#body_html' do
    it 'sets the body html' do
      n = Macaco::Message.new
      n.body_html '<h1>This is a test</h1>'
      n.body_html.must_equal '<h1>This is a test</h1>'
    end
  end

  describe '#body_text' do
    it 'sets the body text' do
      n = Macaco::Message.new
      n.body_text 'This is a test'
      n.body_text.must_equal 'This is a test'
    end
  end
  
end