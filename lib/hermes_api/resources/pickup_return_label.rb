module HermesAPI
  class PickupReturnLabel < Base
    # Create return label(s) with courier pickup request.
    # HermesUK doc: https://drive.google.com/file/d/1lVuHd2o4nDWrGkacG0GrvNm7LYVL_bFd/view?usp=sharing
    # You can choose to create a batch of return labels by passing in multiple collectionRoutingRequestEntry.
    # Example:
    # HermesAPI::Base.with_session("username", "password") do
    #   request_body = {clientId: "249",
    #                   clientName: "Leggings",
    #                   childClientId: "",
    #                   childClientName: "",
    #                   sourceOfRequest: "CLIENTWS",
    #                   routingStartDate: Time.now.tomorrow.strftime("%Y-%m-%dT%H:%M:%S"),
    #                   collectionRoutingRequestEntries: [{ # collectionRoutingRequestEntry
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
    #                     parcel: {
    #                       weight: 1,
    #                       length: 10,
    #                       width: 10,
    #                       depth: 10,
    #                       girth: 0,
    #                       combinedDimension: 0,
    #                       volume: 0,
    #                       value: 10,
    #                       description: "Parcel"
    #                     },
    #                     countryOfOrigin: "GB"
    #                   }]}
    #   @order = HermesAPI::PickupReturnLabel.new(request_body)
    #   @order.save
    # end

    include ReturnLabelHelper

    self.prefix = "/routing/service/rest/v4/routeCollectionCreatePreadviceReturnBarcodeAndLabel"
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
          parcel: {
            weight: 1,
            length: 10,
            width: 10,
            depth: 10,
            girth: 0,
            combined_dimension: 0,
            volume: 0,
            value: 10,
            description: "Parcel"
          },
          mobile_phone_no: "",
          email: "",
          customer_reference1: ""
        },
        country_of_origin: ""
      }]
    }
  end
end
