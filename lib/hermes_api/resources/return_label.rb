module HermesAPI
  class ReturnLabel < Base
    # Create return label(s).
    # You can choose to create a batch of return labels by passing in multiple collectionRoutingRequestEntry.
    # Example:
    # HermesAPI::Base.with_session("username", "password") do
    #   request_body = {clientId: "1234",
    #                   clientName: "Life",
    #                   childClientId: "",
    #                   childClientName: "",
    #                   sourceOfRequest: "CLIENTWS",
    #                   collectionRoutingRequestEntries: [{ #collectionRoutingRequestEntry
    #                     customer: {
    #                       address: {
    #                         firstName: "Leonie", lastName: "E", houseName: "2", streetName: "Street",
    #                         addressLine1: "2 Street", addressLine2: "Fulham", postCode: "SW6 6EL",
    #                         city: "London", region: "", countryCode: "GB"
    #                       },
    #                       mobilePhoneNo: "+447884571522",
    #                       email: "leonie@london.com",
    #                       customerReference1: "8284"
    #                     },
    #                     countryOfOrigin: "GB"
    #                   }]}
    #   @order = HermesAPI::ReturnLabel.new(request_body)
    #   @order.save
    #
    #   # Request for a single print in store QR code by wrapping in an oauth session block, only work with 1 label.
    #   # To request a batch of QR codes, use the HermesAPI::PrintInStoreQrCode#create directly.
    #
    #   HermesAPI::PrintInStoreQrCode.with_oauth_session("api_key", "client_id/auth_id", "client_secret/auth_secret") do
    #     @order.request_print_in_store_qr_code(
    #       deliveryAddress: {
    #         name: "Andy",
    #         addressLine1: "7 Street",
    #         addressLine2: "Fulham",
    #         countryCode: "GB",
    #         postcode: "SW6 6EL"
    #       },
    #       dimensions: {
    #         depth: 15,
    #         length: 20,
    #         width: 15,
    #         weight: 1
    #       },
    #       value: {
    #         currency: "GBP",
    #         amount: 10
    #       }
    #     )
    #   end
    # end
    #
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

    def request_print_in_store_qr_code(**attrs)
      if ([:dimensions, :value, :deliveryAddress] - attrs.keys).length > 0
        raise ArgumentError, request_print_in_store_qr_code_error_message
      end

      return nil if attributes["routingResponseEntries"].blank?

      entries = routingResponseEntries.routingResponseEntry
      entry = entries.is_a?(Array) ? entries[0] : entries
      carrier = entry.inboundCarriers.carrier1
      barcode = carrier.barcode1
      customer = collectionRoutingRequestEntries[0].customer
      address = customer.address
      self.print_in_store_qr_code = PrintInStoreQrCode.create(
        customer: {
          customerReference1: customer.customerReference1
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

    private

    def request_print_in_store_qr_code_error_message
      <<~HEREDOC
        Missing attributes
        Example:
        HermesAPI::ReturnLabel#request_print_in_store_qr_code(
          dimensions: {
            depth: 15,
            length: 20,
            width: 15,
            weight: 1
          },
          value: {
            currency: 'GBP',
            amount: 10
          },
          deliveryAddress: {
            name: 'Don Joe',
            addressLine1: 'Real Logic',
            addressLine2: '4-4 Ridings Park, Eastern Way',
            countryCode: 'GB',
            postcode: 'WS117FJ'
          }
        )
      HEREDOC
    end
  end
end
