require 'bring/base_request'

module Bring
  class PostalCode < BaseRequest
    @@cities = {}
    attr_reader :postal_code, :country

    def self.reset_cache!
      @@cities.clear
    end

    def initialize(pnr, options = {})
      @postal_code = pnr
      @country = options[:country] || 'no'
    end

    def city
      @@cities[postal_code] ||= request.body['result']
    end

    private
    def request
      connection.get do |req|
       req.params['pnr']     = postal_code
       req.params['country'] = country
      end
    end

    def api_url
      'http://fraktguide.bring.no/fraktguide/api/postalCode.json'.freeze
    end
  end
end
