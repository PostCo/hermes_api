module HermesAPI
  class PrintInStoreQrCode < JsonBase
    self.element_name = ""
    self.prefix = "/client-print-in-store-api/v1/references"

    def load(attributes, remove_root = false, persisted = false)
      # remove the outer array before parsing the response body
      attributes = attributes[0] if attributes.is_a?(Array) && attributes.length == 1
      super
    end

    def qr_code_image
      base64_data = as_json.dig("qr_code", "base64_encoded_bytes")
      Base64.decode64(base64_data) if base64_data
    end
  end
end
