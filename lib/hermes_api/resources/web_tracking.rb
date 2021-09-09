module HermesAPI
  class WebTracking < ActiveResource::Base
    # # Retrieve TrackingEvents from web site: https://www.myhermes.co.uk/track
  
    # HermesAPI::WebTracking.find("1234512345")
    
    self.element_name = ""
    self.site = "https://api.hermesworld.co.uk"
    self.prefix = "/enterprise-tracking-api/v1/parcels"
    self.include_format_in_path = false
    headers["apiKey"] = ENV["HERMES_WEB_TRACKING_API_KEY"]

    MAPPING = {
      "715" => "pending_drop_off",
      "708" => "dropped_off",
      "690" => "dropped_off",
      "710" => "collected_by_courier",
      "688" => "collected_by_courier",
      "689" => "collected_by_courier",
      "711" => "collected_by_courier"
    }

    def load(attributes, remove_root = false, persisted = false)
      attributes = attributes.dig("results", 0)
      attributes.deep_transform_keys! { |k| k.to_s.underscore }
      super
    end

    def self.find(barcode)
      uniqueId = format.decode(connection.get("#{prefix}/search/#{barcode}", headers).body).first
      return nil if uniqueId.nil?

      find_single("", params: {uniqueIds: uniqueId})
    end
  end
end
