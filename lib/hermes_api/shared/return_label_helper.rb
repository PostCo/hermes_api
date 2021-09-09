module HermesAPI
  module ReturnLabelHelper
    module ClassMethods
      def root
        :collectionRoutingRequest
      end
    end

    def self.included(base_klass)
      base_klass.extend(ClassMethods)
    end

    def labels
      entries = routing_response_entries.routing_response_entry
      if entries.is_a?(Array)
        entries.map do |entry|
          Base64.decode64(entry.inbound_carriers.label_image)
        end
      else
        Base64.decode64(entries.inbound_carriers.label_image)
      end
    rescue NameError
    end

    alias_method :label, :labels

    def tracking_numbers
      entries = routing_response_entries.routing_response_entry
      if entries.is_a?(Array)
        entries.map do |entry|
          entry.inbound_carriers.carrier1.barcode1.barcode_number
        end
      else
        entries.inbound_carriers.carrier1.barcode1.barcode_number
      end
    rescue NameError
    end

    alias_method :tracking_number, :tracking_numbers
  end
end
