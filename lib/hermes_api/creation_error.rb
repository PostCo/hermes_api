module HermesAPI
  class CreationError < ActiveResource::ConnectionError
    def data
      ActiveResource::Formats::XmlFormat.decode(@response.body)
    end

    def to_s
      response = ActiveResource::Formats::XmlFormat.decode(@response.body)
      entries = response.dig("routingResponseEntries", "routingResponseEntry")
      if entries.is_a? Array
        entries.map do |entry|
          error = entry.dig("errorMessages")
          "Something went wrong, Error Code: #{error["errorCode"]}, Error Description: #{error["errorDescription"]}."
        end.to_s
      else
        error = entries.dig("errorMessages")
        "Something went wrong. Error Code: #{error["errorCode"]} Error Description: #{error["errorDescription"]}"
      end
    end
  end
end
