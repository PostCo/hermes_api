module HermesAPI
  class OAuth < ActiveResource::Base
    self.include_format_in_path = false
    self.element_name=""
    self.prefix="/oauth/token"

    def initialize(attributes = {}, persisted = false)
      attributes = {
        grant_type: "client_credentials",
        client_id: HermesAPI.config.auth_id,
        client_secret: HermesAPI.config.auth_secret,
        **attributes
      }
      super
    end
  end
end