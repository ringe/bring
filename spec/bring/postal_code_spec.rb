require 'spec_helper'
require 'bring/postal_code'

describe Bring::PostalCode do
  describe 'city' do
    use_vcr_cassette 'postal_code'
    before do
      Bring::PostalCode.reset_cache!
    end

    it "fetches result from Bring's API" do
      postal_code = Bring::PostalCode.new('0190')

      expect(postal_code.city).to eq 'OSLO'
    end

    it "keeps result in memory" do
      Bring::PostalCode.new('0190').city

      expect { Bring::PostalCode.new('0190').city }.not_to raise_error
    end

    context 'when country is sweden' do
      use_vcr_cassette 'postal_code_se'

      it "fetches result from Bring's API" do
        postal_code = Bring::PostalCode.new('12000', :country => 'se')

        expect(postal_code.city).to eq 'Stockholm'
      end
    end
  end
end
