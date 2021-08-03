module HermesAPI
  class PrintInStoreQr < JsonBase
    self.element_name = ""
    self.prefix = "/client-print-in-store-api/v1/references"

    OAUTH_AUDIENCE = "client-print-in-store-api"

    def load(attributes, remove_root = false, persisted = false)
      # remove the outer array before parsing the response body
      attributes = attributes[0] if attributes.is_a?(Array) && attributes.length == 1
      super
    end
  end
end
