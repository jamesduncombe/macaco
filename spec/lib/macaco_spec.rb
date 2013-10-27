require 'spec_helper'

describe Macaco do

  describe '#configure' do
    it 'configures the gem' do
      Macaco.configure do |config|
        config.api_key = 'dfsdf'
      end
      Macaco.config.api_key.must_match 'dfsdf'
    end
  end
end
