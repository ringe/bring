require 'date'
require 'bring/base_request'

module Bring
  class Tracking < BaseRequest
    attr_reader :tracking_number

    def initialize(tracking_number)
      @tracking_number = tracking_number
    end

    class Error < StandardError
    end

    class ApiClass
      def initialize(data)
        @data = data
        raise(Error, error_message) if has_errors?
      end

      def has_errors?
        !data['error'].nil?
      end

      def error_message
        "#{data['error']['message']} (#{data['error']['code']})"
      end


      def self.attribute(name)
        define_method name do
          data[camelize(name)]
        end
      end

      private
      def data
        @data
      end

      def camelize(string)
        string.to_s.split('_').each_with_index { |word, index|
          word.capitalize! unless index == 0
        }.join
      end
    end

    class Address < ApiClass
      attribute :address_line_1
      attribute :address_line_2
      attribute :postal_code
      attribute :city
      attribute :country_code
      attribute :country

      def to_s
        address =
          [ address_line_1, address_line_2, "#{postal_code} #{city}", country ]
        address.delete_if { |line| line.nil? || line == '' }
        address.join(', ')
      end
    end

    class Definition < ApiClass
      attribute :term
      attribute :explanation
    end

    class Event < ApiClass
      attribute :description
      attribute :status
      attribute :unit_id
      attribute :unit_information_url
      attribute :unit_type
      attribute :postal_code
      attribute :city
      attribute :country_code
      attribute :country
      attribute :date_iso
      attribute :display_date
      attribute :display_time
      attribute :consignment_event

      def postal_code?
        !(postal_code.nil? or postal_code.empty?)
      end

      def date
        @date ||= DateTime.strptime(date_iso)
      end

      def definitions
        return [] if data['definitions'].nil?
        data['definitions'].map { |attr| Definition.new attr }
      end

      def color
        case status
        when 'READY_FOR_PICKUP' then :yellow
        when 'DELIVERED'        then :green
        end
      end
    end

    class Package < ApiClass
      attribute :status_description
      attribute :descriptions
      attribute :package_number
      attribute :previous_package_number
      attribute :product_name
      attribute :product_code
      attribute :brand
      attribute :length_in_cm
      attribute :width_in_cm
      attribute :height_in_cm
      attribute :volume_in_dm3
      attribute :weight_in_kgs
      attribute :pickup_code
      attribute :sender_name

      def date_of_return
        return if data['dateOfReturn'].nil?
        @date_of_return ||= Date.strptime(data['dateOfReturn'], '%d.%m.%Y')
      end

      def recipient_address
        return unless data['recipientAddress'].is_a?(Hash)
        @address ||= Address.new(data['recipientAddress'])
      end

      def events
        @events ||= data['eventSet'].map { |attr| Event.new(attr) }
      end
    end

    class Consignment < ApiClass
      attribute :consignment_id
      attribute :previous_consignment_id
      attribute :total_weight_in_kgs
      attribute :total_volume_in_dm3

      def packages
      return [] if data['packageSet'].nil?
        @packages ||=
          data['packageSet'].map { |attr| Package.new attr }
      end
    end

    def consignments
      return [] if data['consignmentSet'].nil?
      @consignments ||=
        data['consignmentSet'].map { |attr| Consignment.new attr }
    end

    private
    def data
      @data ||= connection.get do |req|
        req.params['q'] = tracking_number
      end.body
    end

    def api_url
      'http://sporing.bring.no/sporing.json'.freeze
    end
  end
end
