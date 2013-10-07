require 'thor'

module Bring
  class CLI < Thor
    desc 'postal_code PNR', 'get city from PNR'
    option :country, :default => 'no'
    def postal_code(pnr)
      require 'bring/postal_code'
      puts PostalCode.new(pnr, :country => options[:country]).city
    end

    desc 'tracking TRACKING_NUMBER', 'get tracking data from TRACKING_NUMBER'
    option :full,  :type => :boolean
    option :color, :type => :boolean, :default => true
    def tracking(tracking_number)
      require 'bring/tracking'
      begin
        tracking = Tracking.new(tracking_number)

        tracking.consignments.each do |consignment|
          say "Shipment Number: #{consignment.consignment_id}", :white
          say "Total Weight: #{consignment.total_weight_in_kgs} kg"
          say "Total Volume: #{consignment.total_volume_in_dm3} dm3"
          say "Number of Packages: #{consignment.packages.count}"

          consignment.packages.each do |package|
            say ""
            say "Package Number: #{package.package_number}", :white

            if package.sender_name
              say "Sender: #{package.sender_name}"
            end

            if package.recipient_address
              say "Recipient: #{package.recipient_address.to_s}"
            end

            sizes =
              [package.length_in_cm, package.width_in_cm, package.height_in_cm]
            say "Measurements: #{sizes.join('x')} cm (LxWxH)"

            if package.date_of_return
              say "Last day for retrieval: #{package.date_of_return}"
            end

            package.events.each_with_index do |event, index|
              color = event.color if options[:color]
              say ""
              say "Status: #{event.status}", color
              say event.description

              say "#{event.date.strftime('%Y-%m-%d %H:%M')}", nil, false
              if event.postal_code?
                say ", #{event.postal_code} #{event.city}", nil, false
              end
              say ''

              break unless options[:full] || index > 0
            end
          end
        end
      rescue Bring::Tracking::Error => exception
        raise Thor::Error, exception.message
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end
