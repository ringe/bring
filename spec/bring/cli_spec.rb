# encoding: utf-8
require 'spec_helper'
require 'bring/cli'

describe Bring::CLI do
  def invoke!(*args)
    capture(:stdout) { Bring::CLI.start(args) }
  end

  describe 'postal_code', :vcr => { :cassette_name => 'postal_code' } do
    it 'displays city for pnr' do
      expect(invoke! 'postal_code', '0190').to eq "OSLO\n"
    end

    it 'takes a country', :vcr => { :cassette_name => 'postal_code_se' } do
      arguments = %w[postal_code 12000 --country se]
      expect(invoke!(*arguments)).to eq "Stockholm\n"
    end
  end

  describe 'tracking' do
    use_vcr_cassette 'tracking_ready_for_pickup'
    let(:output) { invoke!('tracking', 'TESTPACKAGE-AT-PICKUPPOINT') }

    it 'displays shipment number' do
      expect(output).to include 'Shipment Number: SHIPMENTNUMBER'
    end

    it 'displays sender' do
      expect(output).to include 'Sender: POSTEN NORGE AS'
    end

    it 'displays recipient' do
      expect(output).to include 'Recipient: 1407 VINTERBRO'
    end

    it 'displays packing number' do
      expect(output).to include 'Package Number: TESTPACKAGEATPICKUPPOINT'
    end

    it 'displays package size' do
      expect(output).to include 'Measurements: 41x38x29 cm (LxWxH)'
    end

    it 'displays package weight' do
      expect(output).to include 'Weight: 16.5 kg'
    end

    it 'displays number of packages' do
      expect(output).to include 'Number of Packages: 1'
    end

    it 'only displays most recent status' do
      expect(output).to include 'Status: READY_FOR_PICKUP'
      expect(output).not_to include 'Status: IN_TRANSIT'
    end

    it 'displays date and location' do
      expect(output).to include '2010-10-01 08:30, 2341 LØTEN'
    end

    it 'displays last day for retrieval' do
      expect(output).to include 'Last day for retrieval: 2011-12-01'
    end

    context 'with --full' do
      let(:output) { invoke!('tracking', 'TESTPACKAGE-AT-PICKUPPOINT', '--full') }

      it 'displays all events' do
        expect(output).to include 'Status: READY_FOR_PICKUP'
        expect(output).to include 'Status: IN_TRANSIT'
      end
    end

    context 'with status PRE_NOTIFIED' do
      use_vcr_cassette 'tracking_pre_notified'
      let(:output) { invoke!('tracking', 'TESTPACKAGE-EDI') }

      it 'displays status' do
        expect(output).to include %q{
Status: PRE_NOTIFIED
Ingen sending er mottatt ennå, kun melding om dette
2013-10-06 12:44
}
      end
    end

    context 'with status READY_FOR_PICKUP' do
      let(:output) { invoke!('tracking', 'TESTPACKAGE-AT-PICKUPPOINT') }

      it 'displays status' do
        expect(output).to include %q{
Status: READY_FOR_PICKUP
Sendingen er ankommet postkontor
2010-10-01 08:30, 2341 LØTEN}
      end
    end

    context 'with status TRANSPORT_TO_RECIPIENT' do
      use_vcr_cassette 'tracking_transport_to_recipient'
      let(:output) { invoke!('tracking', 'TESTPACKAGE-LOADED-FOR-DELIVERY') }

      it 'displays status' do
        expect(output).to include %q{
Status: TRANSPORT_TO_RECIPIENT
Sendingen er lastet opp for utkjøring
2010-09-30 16:48, 0001 OSLO}
      end
    end

    context 'with status DELIVERED' do
      use_vcr_cassette 'tracking_delivered'
      let(:output) { invoke!('tracking', 'TESTPACKAGE-DELIVERED') }

      it 'displays status' do
        expect(output).to include %q{
Status: DELIVERED
Sendingen er utlevert
2010-09-30 17:45}
      end
    end

    context 'with invalid tracking number' do
      use_vcr_cassette 'tracking_invalid'
      let(:output) { invoke!('tracking', 'FOO') }

      it 'exits with error' do
        expect { output }.to raise_error SystemExit
      end
    end
  end
end
