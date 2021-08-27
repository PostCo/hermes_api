module HermesAPI
  class TrackingEvent < JsonBase
    #   # Retrieve TrackingEvents by wrapping in an oauth session block
    #
    #   HermesAPI::TrackingEvent.with_oauth_session("api_key", "client_id/auth_id", "client_secret/auth_secret") do
    #     HermesAPI::TrackingEvent.where(barcode: "123456789")
    #   end

    self.element_name = ""
    self.prefix = "/client-tracking-api/v1/events"

    def self.where(barcode:)
      super(barcode: barcode, descriptionType: "CLIENT")
    end
  end
end
