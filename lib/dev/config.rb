require "dotenv/load"

def set_config
  HermesAPI.configure do |config|
    config.user = ENV["HERMES_API_USER"]
    config.password = ENV["HERMES_API_PASSWORD"]
    config.env = :test
    config.proxy = ENV["HERMES_API_PROXY"]
    config.auth_id = ENV["HERMES_API_AUTH_ID"]
    config.auth_secret = ENV["HERMES_API_AUTH_SECRET"]
    config.api_key = ENV["HERMES_API_KEY"]
  end
end
