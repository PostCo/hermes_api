module HermesAPI
  class TrackingEvent < JsonBase
    extend HermesAPI::BearerTokenSetup

    self.element_name = ""
    self.prefix = "/client-tracking-api/v1/events"

    def self.where(barcode:)
      super(barcode: barcode, descriptionType: "CLIENT")
    end
  end
end
