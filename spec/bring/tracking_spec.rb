# encoding: utf-8
require 'spec_helper'
require 'bring/tracking'

describe Bring::Tracking, :vcr do
  let(:tracking) { Bring::Tracking.new 'TESTPACKAGE-AT-PICKUPPOINT' }

  describe 'consignments' do
    it 'returns an array of consignments' do
      expect(tracking.consignments).to be_a Array
      expect(tracking.consignments.first).to be_a Bring::Tracking::Consignment
    end
  end

  describe Bring::Tracking::Address do
    let(:address) { tracking.consignments.first.packages.first.recipient_address}

    describe 'address_line_1' do
      it 'returns address line 1' do
        expect(address.address_line_1).to eq ''
      end
    end

    describe 'address_line_2' do
      it 'returns address line 2' do
        expect(address.address_line_2).to eq ''
      end
    end

    describe 'postal_code' do
      it 'returns postal code' do
        expect(address.postal_code).to eq '1407'
      end
    end

    describe 'city' do
      it 'returns city' do
        expect(address.city).to eq 'VINTERBRO'
      end
    end

    describe 'country_code' do
      it 'returns country code' do
        expect(address.country_code).to eq ''
      end
    end

    describe 'country' do
      it 'returns country' do
        expect(address.country).to eq ''
      end
    end
  end

  describe Bring::Tracking::Definition do
    let(:event) { tracking.consignments.first.packages.first.events.last }
    let(:definition) { event.definitions.last }

    describe 'term' do
      it 'returns term' do
        expect(definition.term).to eq 'terminal'
      end
    end

    describe 'explanation' do
      it 'returns explanation' do

    expect(definition.explanation).to eq 'Brev, pakke eller godsterminal som benyttes til sortering  og omlasting av sendinger som er underveis til mottaker.'
      end
    end
  end

  describe Bring::Tracking::Event do
    let(:events) { tracking.consignments.first.packages.first.events }
    let(:event) { events.first }

    describe 'description' do
      it 'returns description' do
        expect(event.description).to eq 'Sendingen er ankommet postkontor'
      end
    end

    describe 'status' do
      it 'returns status' do
        expect(event.status).to eq 'READY_FOR_PICKUP'
      end
    end

    describe 'unit_id' do
      it 'returns unit id' do
        expect(event.unit_id).to eq '122608'
      end
    end

    describe 'unit_information_url' do
      it 'returns unit information url' do
        expect(event.unit_information_url).
          to eq 'http://fraktguide.bring.no/fraktguide/api/pickuppoint/id/122608'
      end
    end

    describe 'unit_type' do
      it 'returns unit type' do
        expect(event.unit_type).to eq 'BRING'
      end
    end

    describe 'postal_code' do
      it 'returns postal code' do
        expect(event.postal_code).to eq '2341'
      end
    end

    describe 'city' do
      it 'returns city' do
        expect(event.city).to eq 'LØTEN'
      end
    end

    describe 'country_code' do
      it 'returns the country code' do
        expect(event.country_code).to eq 'NO'
      end
    end

    describe 'country' do
      it 'returns the country' do
        expect(event.country).to eq 'Norway'
      end
    end

    describe 'date_iso' do
      it 'returns iso-formatted date' do
        expect(event.date_iso).to eq '2010-10-01T08:30:25+02:00'
      end
    end

    describe 'display_date' do
      it 'returns display date' do
        expect(event.display_date).to eq "01.10.2010"
      end
    end

    describe 'display_time' do
      it 'returns display time' do
        expect(event.display_time).to eq "08:30"
      end
    end

    describe 'date' do
      it 'returns datetime' do
        expect(event.date).to be_a(DateTime)
      end

      it 'equals to date_iso' do
        expect(event.date.to_s).to eq event.date_iso
      end
    end

    describe 'consignment_event' do
      it 'returns consignment event' do
        expect(event.consignment_event).to eq false
      end
    end

    describe 'definitions' do
      it 'returns array of definitions' do
        expect(event.definitions).to be_a Array
      end
    end

    # "eventSet": [
    # {
    #   "description": "Sendingen er ankommet postkontor",
    #   "status": "READY_FOR_PICKUP",
    #   "recipientSignature": {
    #     "name": ""
    #   },
    #   "unitId": "122608",
    #   "unitInformationUrl": "http://fraktguide.bring.no/fraktguide/api/pickuppoint/id/122608",
    #   "unitType": "BRING",
    #   "postalCode": "2341",
    #   "city": "LØTEN",
    #   "countryCode": "NO",
    #   "country": "Norway",
    #   "dateIso": "2010-10-01T08:30:25+02:00",
    #   "displayDate": "01.10.2010",
    #   "displayTime": "08:30",
    #   "consignmentEvent": false
    # },
    # {
    #   "description": "Sendingen er innlevert til terminal og videresendt",
    #   "status": "IN_TRANSIT",
    #   "recipientSignature": {
    #     "name": ""
    #   },
    #   "unitId": "032850",
    #   "unitType": "BRING",
    #   "postalCode": "0024",
    #   "city": "OSLO",
    #   "countryCode": "NO",
    #   "country": "Norway",
    #   "dateIso": "2010-09-30T08:27:08+02:00",
    #   "displayDate": "30.09.2010",
    #   "displayTime": "08:27",
    #   "consignmentEvent": false,
    #   "definitions": [
    #     {
    #       "term": "terminal",
    #       "explanation": "Brev, pakke eller godsterminal som benyttes til sortering  og omlasting av sendinger som er underveis til mottaker."
    #     }
    #   ]
    # }
    #
  end

  describe Bring::Tracking::Package do
    let(:package) { tracking.consignments.first.packages.first }

    describe 'status_description' do
      it 'returns status description' do
        expect(package.status_description).
          to eq 'Sendingen kan hentes på postkontor.'
      end
    end

    describe 'descriptions' do
      it 'returns array of descriptions' do
        expect(package.descriptions).to be_a Array
      end
    end

    describe 'package_number' do
      it 'returns package number' do
        expect(package.package_number).to eq 'TESTPACKAGEATPICKUPPOINT'
      end
    end

    describe 'previous_package_number' do
      it 'returns previous package number' do
        expect(package.previous_package_number).to eq ''
      end
    end

    describe 'product_name' do
      it 'returns product name' do
        expect(package.product_name).to eq 'KLIMANØYTRAL SERVICEPAKKE'
      end
    end

    describe 'product_code' do
      it 'returns product code' do
        expect(package.product_code).to eq '1202'
      end
    end

    describe 'brand' do
      it 'returns brand' do
        expect(package.brand).to eq 'POSTEN'
      end
    end

    describe 'length_in_cm' do
      it 'returns length in cm' do
        expect(package.length_in_cm).to eq 41
      end
    end

    describe 'width_in_cm' do
      it 'returns width in cm' do
        expect(package.width_in_cm).to eq 38
      end
    end

    describe 'height_in_cm' do
      it 'returns height in cm' do
        expect(package.height_in_cm).to eq 29
      end
    end

    describe 'volume_in_dm3' do
      it 'returns volume in dm3' do
        expect(package.volume_in_dm3).to eq 45.2
      end
    end

    describe 'weight_in_kgs' do
      it 'returns weight in kg' do
        expect(package.weight_in_kgs).to eq 16.5
      end
    end

    describe 'pickup_code' do
      it 'returns pickup code' do
        expect(package.pickup_code).to eq 'AA11'
      end
    end

    describe 'date_of_return' do
      it 'is a DateTime' do
        expect(package.date_of_return).to be_a Date
      end

      it 'returns date of return' do
        expect(package.date_of_return.to_s).to eq '2011-12-01'
      end
    end

    describe 'sender_name' do
      it 'returns sender name' do
        expect(package.sender_name).to eq 'POSTEN NORGE AS'
      end
    end

    describe 'recipient_address' do
      it 'returns a Address' do
        expect(package.recipient_address).to be_a Bring::Tracking::Address
      end
    end

    describe 'events' do
      it 'returns an Array of events' do
        expect(package.events).to be_a Array
        expect(package.events.first).to be_a Bring::Tracking::Event
      end
    end
  end

  describe Bring::Tracking::Consignment do
    let(:consignment) { tracking.consignments.first }

    describe 'consignment_id' do
      it 'returns consignment id' do
        expect(consignment.consignment_id).to eq 'SHIPMENTNUMBER'
      end
    end

    describe 'previous_consignment_id' do
      it 'returns previous consignment id' do
        expect(consignment.previous_consignment_id).to eq ''
      end
    end

    describe 'total_weight_in_kgs' do
      it 'returns weight in kg' do
        expect(consignment.total_weight_in_kgs).to eq 16.5
      end
    end

    describe 'total_volume_in_dm3' do
      it 'returns volume in dm3' do
        expect(consignment.total_volume_in_dm3).to eq 45.2
      end
    end
  end
end
