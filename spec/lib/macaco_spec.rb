require 'spec_helper'

describe Macaco do

  describe '#configure' do
    it 'configures the gem' do
      Macaco.configure do |config|
        config.api_key = 'YOUR_API_KEY'
      end
      Macaco.config.api_key.must_match 'YOUR_API_KEY'
    end
  end
end
