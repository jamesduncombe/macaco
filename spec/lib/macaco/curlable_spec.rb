require 'spec_helper'

describe Macaco::Curlable do

  describe '#form_data' do
    it 'returns a curl command' do
      Macaco::Curlable.new(
        headers: { 'Content-Type' => 'multipart/form-data' },
        api_root: 'requestb.in',
        api_path: '/1jp347b1',
        data: { name: 'form-data', another: 'thing' }).to_curl.must_be_kind_of String
    end
  end

  describe '#json' do
    it 'returns a curl command' do
      Macaco::Curlable.new(
        headers: { 'Content-Type' => 'application/json' },
        api_root: 'requestb.in',
        api_path: '/1jp347b1',
        data: { name: 'json', another: 'thing' }).to_curl.must_be_kind_of String
    end
  end

  describe '#x_www_form_urlencoded' do
    it 'returns a curl command' do
      Macaco::Curlable.new(
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        api_root: 'requestb.in',
        api_path: '/1jp347b1',
        data: { name: 'www_form_urlencoded', another: 'thing' }).to_curl.must_be_kind_of String
    end
  end

end
