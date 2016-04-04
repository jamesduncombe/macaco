require 'spec_helper'
require 'stringio'

describe Macaco::Multipart do

  let(:multipart) do
    mail = Macaco::Sendgrid.new(to: 'test@sink.sendgrid.net', attachment: './README.md' )
    Macaco::Multipart.new(mail)
  end

  describe 'main class' do
    it { multipart.must_respond_to :read }
    it { multipart.must_respond_to :close }
    it { multipart.must_respond_to :size }
  end

  describe '#build_stream' do
    subject { multipart.read.split("\r\n") }
    it { subject.first.must_match /--[0-9]+/ }
    it { subject.last.must_match /--[0-9]+--/ }
  end

  describe '#build_part' do
    subject { multipart.build_part(StringIO.new, :key, 'value') }
    it { subject.string.must_match "Content-Disposition: form-data; name=\"key\"\r\n\r\nvalue" }
  end

end
