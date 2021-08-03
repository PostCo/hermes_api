module HermesAPI
  class JsonBase < ActiveResource::Base
    self.include_format_in_path = false
    self.auth_type = :bearer

    OAUTH_AUDIENCE = nil

    def save
      token = HermesAPI.cache.read("#{self.class.name}/oauth_token") || fetch_token
      connection.bearer_token = token
      super
    end

    private

    def fetch_token
      response = OAuth.create(audience: self.class::OAUTH_AUDIENCE)
      HermesAPI.cache.write(
        "#{self.class.name}/oauth_token",
        response.access_token,
        expires_in: response.expires_in - 15 # clear cache earlier
      )
      response.access_token
    end
  end
end
