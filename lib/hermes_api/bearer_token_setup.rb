module HermesAPI
  module BearerTokenSetup
    def connection(refresh = false)
      connection = super
      connection.bearer_token = fetch_token
      connection
    end

    def fetch_token
      oauth_audience = prefix.match(/^\/?([^\/]*)/).captures.first
      cached_token = HermesAPI.cache.read("#{oauth_audience}/oauth_token")
      return cached_token if cached_token

      response = OAuth.create(audience: oauth_audience)
      HermesAPI.cache.write(
        "#{oauth_audience}/oauth_token",
        response.access_token,
        expires_in: response.expires_in - 15 # clear cache earlier
      )
      response.access_token
    end
  end
end
