require 'thor'

module Bring
  class CLI < Thor
    desc 'postal_code PNR', 'get city from PNR'
    option :country, :default => 'no'
    def postal_code(pnr)
      require 'bring/postal_code'
      puts PostalCode.new(pnr, :country => options[:country]).city
    end
  end
end
