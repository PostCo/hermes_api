module HermesAPI
  class OAuth < ActiveResource::Base
    self.include_format_in_path = false
    self.element_name = ""
    self.prefix = "/oauth/token"

    def initialize(attributes = {}, persisted = false)
      attributes = {
        grant_type: "client_credentials",
        **attributes
      }
      super
    end
  end
end
