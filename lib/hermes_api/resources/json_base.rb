module HermesAPI
  class JsonBase < ActiveResource::Base
    self.include_format_in_path = false
    self.auth_type = :bearer

    def self.inherited(subclass)
      subclass.extend(BearerAuth)
    end
  end
end
