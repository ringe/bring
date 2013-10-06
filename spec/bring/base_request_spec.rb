require 'spec_helper'
require 'bring/base_request'

class MockRequest < Bring::BaseRequest
  def api_url
    'http://example.org/foo.json'.freeze
  end

  def connection
    super
  end
end

describe Bring::BaseRequest do
  let(:base_request) { MockRequest.new }

  describe 'connection' do
    it 'returns faraday connection' do
      expect(base_request.connection).to be_a Faraday::Connection
    end
  end
end
