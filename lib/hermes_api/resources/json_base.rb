module HermesAPI
  class JsonBase < ActiveResource::Base
    self.include_format_in_path = false
    self.auth_type = :bearer
  end
end
