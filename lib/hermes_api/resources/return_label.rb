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

    alias_method :label, :labels

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

    alias_method :tracking_number, :tracking_numbers

    def request_print_in_store_qr_code(attrs = {
      dimensions: {
        depth: 15,
        length: 20,
        width: 15,
        weight: 1
      },
      value: {
        currency: "GBP",
        amount: 10
      }
    })
      return nil if attributes["routingResponseEntries"].blank?

      entries = routingResponseEntries.routingResponseEntry
      entry = entries.is_a?(Array) ? entries[0] : entries
      carrier = entry.inboundCarriers.carrier1
      barcode = carrier.barcode1
      customer = collectionRoutingRequestEntries[0].customer
      address = customer.address

      self.print_in_store_qr_code = PrintInStoreQr.create(
        customer: {
          customerReference1: customer.customerReference1
        },
        deliveryAddress: {
          name: "#{address.firstName} #{address.lastName}",
          addressLine1: address.addressLine1,
          countryCode: address.countryCode,
          postcode: address.postCode
        },
        labelType: "RETURN",
        barcode: {
          barcode: barcode.barcodeNumber,
          barcodeDisplay: barcode.barcodeDisplay
        },
        client: {
          clientId: clientId,
          clientName: clientName
        },
        routing: {
          deliveryMethod: {
            deliveryMethodId: carrier.deliveryMethodCode,
            deliveryMethodDescription: carrier.deliveryMethodDesc
          },
          sortLevels: {
            sortLevel1: carrier.sortLevel1.strip,
            sortLevel2: carrier.sortLevel2
          }
        },
        serviceOffers: [],
        **attrs
      )
    end

    def base64_print_in_store_qr_code
      as_json.dig("print_in_store_qr_code", "qrCode", "base64EncodedBytes")
    end
  end
end
