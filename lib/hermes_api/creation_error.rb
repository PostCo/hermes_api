module HermesAPI
  class CreationError < ActiveResource::ConnectionError
    def data
      ActiveResource::Formats::XmlFormat.decode(@response.body)
    end

    def code
      if entries.is_a? Array
        entries.map do |entry|
          entry.dig("errorMessages", "errorCode")
        end
      else
        entries.dig("errorMessages", "errorCode")
      end
    end

    alias_method :codes, :code

    def description
      unless entries.is_a? Array
        entries.dig("errorMessages", "errorDescription")
      end
    end

    def code_with_descriptions
      if entries.is_a? Array
        entries.map do |entry|
          code = entry.dig("errorMessages", "errorCode")
          description = entry.dig("errorMessages", "errorDescription")
          "#{code}: #{description}"
        end
      end
    end

    def to_s
      if entries.is_a? Array
        "#{code_with_descriptions.join(", ")}."
      else
        "#{code}: #{description}."
      end
    end

    private

    def decoded_response
      ActiveResource::Formats::XmlFormat.decode(@response.body)
    end

    def entries
      decoded_response.dig("routingResponseEntries", "routingResponseEntry")
    end
  end
end
