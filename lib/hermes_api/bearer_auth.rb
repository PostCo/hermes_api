module HermesAPI
  module BearerAuth
    def with_oauth_session(api_key, client_id, client_secret)
      existing_apikey = headers["apikey"]
      existing_bearer_token = connection.bearer_token
      headers["apikey"] = api_key
      connection.bearer_token = fetch_token(client_id, client_secret)
      response = yield
      headers["apikey"] = existing_apikey
      connection.bearer_token = existing_bearer_token
      response
    rescue ActiveResource::UnauthorizedAccess => e
      clear_token_cache(client_id, client_secret)
      raise e
    end

    def oauth_audience
      prefix.match(/^\/?([^\/]*)/).captures.first
    end

    def clear_token_cache(client_id, client_secret)
      cache_key = "HermesAPI/#{client_id}/#{client_secret}/#{oauth_audience}/oauth_token"
      HermesAPI.cache.delete(cache_key)
    end

    def fetch_token(client_id, client_secret)
      cache_key = "HermesAPI/#{client_id}/#{client_secret}/#{oauth_audience}/oauth_token"
      cached_token = HermesAPI.cache.read(cache_key)
      return cached_token if cached_token

      response = OAuth.create(audience: oauth_audience, client_id: client_id, client_secret: client_secret)
      HermesAPI.cache.write(
        cache_key,
        response.access_token,
        expires_in: response.expires_in - 15 # clear cache earlier
      )
      response.access_token
    end
  end
end
