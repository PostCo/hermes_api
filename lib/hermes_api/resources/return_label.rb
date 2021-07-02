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
      sourceOfRequest: "",
      collectionRoutingRequestEntries: [{
        customer: {
          address: {
            title: "",
            firstName: "",
            lastName: "",
            houseNo: "",
            streetName: "",
            countryCode: "",
            postCode: "",
            city: "",
            addressLine1: "",
            region: ""
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

# body = {
#   clientId: "2492",
#   clientName: "Love Leggings",
#   sourceOfRequest: "CLIENTWS",
#   collectionRoutingRequestEntries: [
#     {
#       customer: {
#         address: {
#           title: "Mr",
#           firstName: "Test",
#           lastName: "Customer",
#           houseNo: "1",
#           streetName: "Capitol Close",
#           countryCode: "GB",
#           postCode: "LS27 0WH",
#           city: "Leeds",
#           addressLine1: "Morley",
#           region: "West Yorkshire"
#         },
#         mobilePhoneNo: "789",
#         email: "si@si.com",
#         customerReference1: "Ref1"
#       },
#       countryOfOrigin: "GB"
#     }
#   ]
# }

# faulty_body = {
#   clientId: "2492",
#   clientName: "Love Leggings",
#   sourceOfRequest: "CLIENTWS",
#   collectionRoutingRequestEntries: [
#     {
#       customer: {
#         address: {
#           postCode: "LS27 0WH",
#           city: "Leeds",
#           addressLine1: "Morley",
#           region: "West Yorkshire"
#         },
#         mobilePhoneNo: "789",
#         email: "si@si.com",
#         customerReference1: "Ref1"
#       },
#       countryOfOrigin: "GB"
#     },
#     {
#       customer: {
#         address: {
#           postCode: "LS27 0WH",
#           city: "Leeds",
#           addressLine1: "Morley",
#           region: "West Yorkshire"
#         },
#         mobilePhoneNo: "789",
#         email: "si@si.com",
#         customerReference1: "Ref1"
#       },
#       countryOfOrigin: "GB"
#     }
#   ]
# }
