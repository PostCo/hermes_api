module HermesAPI
  class DropOffReturnLabel < Base
        # Create return label(s) wheredrop off at ParcelShops.
    # HermesUK doc: https://drive.google.com/file/d/1lVuHd2o4nDWrGkacG0GrvNm7LYVL_bFd/view?usp=sharing
    # You can choose to create a batch of return labels by passing in multiple collectionRoutingRequestEntry.
    # Example:
    # HermesAPI::Base.with_session("username", "password") do
    # request_body = {client_id: "1234",
    #                 client_name: "Leggings",
    #                 child_client_id: "",
    #                 child_client_name: "",
    #                 source_of_request: "CLIENTWS",
    #                 collection_routing_request_entries: [{ # collectionRoutingRequestEntry
    #                   customer: {
    #                     address: {
    #                       first_name: "Leonie", lastame: "E", houseName: "2", streetName: "Street",
    #                       addressLine1: "2 Street", addressLine2: "Fulham", postCode: "SW6 6EL",
    #                       city: "London", region: "", countryCode: "GB"
    #                     },
    #                     mobilePhoneNo: "+447884571522",
    #                     email: "leonie@london.com",
    #                     customerReference1: "8284"
    #                   },
    #                   countryOfOrigin: "GB"
    #                 }]}
    # @order = HermesAPI::DropOffReturnLabel.new(request_body)
    # @order.save

    #   # Request for a single print in store QR code by wrapping in an oauth session block, only work with 1 label.
    #   # To request a batch of QR codes, use the HermesAPI::PrintInStoreQrCode#create directly.

    #   HermesAPI::PrintInStoreQrCode.with_oauth_session("api_key", "client_id/auth_id", "client_secret/auth_secret") do
    #     @order.request_print_in_store_qr_code(
    #       delivery_address: {
    #         name: "Andy",
    #         address_line1: "7 Street",
    #         address_line2: "Fulham",
    #         country_code: "GB",
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

    include ReturnLabelHelper

    self.prefix = "/routing/service/rest/v4/createReturnBarcodeAndLabel"
    self.element_name = ""

    DEFAULT_ATTRS = {
      client_id: "",
      client_name: "",
      child_client_id: "",
      child_client_name: "",
      source_of_request: "",
      collection_routing_request_entries: [{
        customer: {
          address: {
            first_name: "",
            last_name: "",
            house_name: "",
            street_name: "",
            address_line1: "",
            post_code: "",
            city: "",
            region: "",
            country_code: ""
          },
          mobile_phone_no: "",
          email: "",
          customer_reference1: ""
        },
        country_of_origin: ""
      }]
    }

    def request_print_in_store_qr_code(**attrs)
      if missing_required_qr_code_attributes?(attrs)
        raise ArgumentError, request_print_in_store_qr_code_error_message
      end

      return nil if attributes["routing_response_entries"].blank?

      entries = routing_response_entries.routing_response_entry
      entry = entries.is_a?(Array) ? entries[0] : entries
      carrier = entry.inbound_carriers.carrier1
      barcode = carrier.barcode1
      customer = collection_routing_request_entries[0].customer
      address = customer.address

      self.print_in_store_qr_code = PrintInStoreQrCode.create(
        customer: {
          customer_reference1: customer.customer_reference1
        },
        label_type: "RETURN",
        barcode: {
          barcode: barcode.barcode_number,
          barcode_display: barcode.barcode_display
        },
        client: {
          client_id: client_id,
          client_name: client_name
        },
        routing: {
          delivery_method: {
            delivery_method_id: carrier.delivery_method_code,
            delivery_method_description: carrier.delivery_method_desc
          },
          sort_levels: {
            sort_level1: carrier.sort_level1.strip,
            sort_level2: carrier.sort_level2
          }
        },
        service_offers: [],
        **attrs
      )
    end

    private

    def missing_required_qr_code_attributes?(attrs)
      ([:dimensions, :value, :delivery_address] - attrs.keys).length > 0
    end

    def request_print_in_store_qr_code_error_message
      <<~ERR_MESSAGE
        Missing required attributes
        Example:

        label = HermesAPI::DropOffReturnLabel.new(...)

        if label.save
          label.request_print_in_store_qr_code(
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
            delivery_address: {
              name: 'Don Joe',
              address_line1: 'Real Logic',
              address_line2: '4-4 Ridings Park, Eastern Way',
              country_code: 'GB',
              postcode: 'WS117FJ'
            }
          )
        end
      ERR_MESSAGE
    end
  end
end
