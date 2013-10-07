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
    option :full, :type => :boolean
    def tracking(tracking_number)
      require 'bring/tracking'
      begin
        tracking = Tracking.new(tracking_number)

        tracking.consignments.each do |consignment|
          say "Shipment Number: #{consignment.consignment_id}"
          puts "Total Weight: #{consignment.total_weight_in_kgs} kg"
          puts "Total Volume: #{consignment.total_volume_in_dm3} dm3"
          puts "Number of Packages: #{consignment.packages.count}"

          consignment.packages.each do |package|
            print "\n"
            puts "Package Number: #{package.package_number}"

            if package.sender_name
              puts "Sender: #{package.sender_name}"
            end

            if package.recipient_address
              puts "Recipient: #{package.recipient_address.to_s}"
            end
            sizes =
              [package.length_in_cm, package.width_in_cm, package.height_in_cm]
            puts "Measurements: #{sizes.join('x')} cm (LxWxH)"

            if package.date_of_return
              puts "Last day for retrieval: #{package.date_of_return}"
            end

            package.events.each_with_index do |event, index|
              print "\n"
              puts "Status: #{event.status}"
              puts event.description

              print "#{event.date.strftime('%Y-%m-%d %H:%M')}"
              if event.postal_code?
                print ", #{event.postal_code} #{event.city}"
              end
              print "\n"

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
