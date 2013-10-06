require 'bring/configurator'
require 'faraday_middleware'

module Bring
  class BaseRequest

    private
    def connection
      @connection ||= Faraday.new(api_url) do |conn|
        conn.request :json
        conn.response :json, :content_type => /\bjson$/
        conn.adapter Bring.config.faraday_adapter || Faraday.default_adapter
      end
    end
  end
end
