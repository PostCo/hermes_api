"
Create return label(s).
You can choose to create a batch of return labels by passing in multiple collectionRoutingRequestEntry.
"
module HermesAPI
  class ReturnLabel < Base
    self.prefix = "/routing/service/rest/v4/createReturnBarcodeAndLabel"
    self.element_name = ""

    DEFAULT_ATTRS = {
      clientId: "",
      clientName: "",
      childClientId: "",
      childClientName: "",
      sourceOfRequest: "",
      collectionRoutingRequestEntries: [{
        customer: {
          address: {
            firstName: "",
            lastName: "",
            houseName: "",
            streetName: "",
            addressLine1: "",
            postCode: "",
            city: "",
            region: "",
            countryCode: ""
          },
          mobilePhoneNo: "",
          email: "",
          customerReference1: ""
        },
        countryOfOrigin: ""
      }]
    }

    def self.root
      :collectionRoutingRequest
    end

    def labels
      entries = routingResponseEntries.routingResponseEntry
      if entries.is_a?(Array)
        entries.map do |entry|
          Base64.decode64(entry.inboundCarriers.labelImage)
        end
      else
        Base64.decode64(entries.inboundCarriers.labelImage)
      end
    rescue NameError
    end

    def tracking_numbers
      entries = routingResponseEntries.routingResponseEntry
      if entries.is_a?(Array)
        entries.map do |entry|
          entry.inboundCarriers.carrier1.barcode1.barcodeNumber
        end
      else
        entries.inboundCarriers.carrier1.barcode1.barcodeNumber
      end
    rescue NameError
    end

    alias_method :label, :labels
    alias_method :tracking_number, :tracking_numbers
  end
end
