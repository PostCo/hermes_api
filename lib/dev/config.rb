require "dotenv/load"

def set_config
  HermesAPI.configure do |config|
    config.user = ENV["HERMES_API_USER"] 
    config.password = ENV["HERMES_API_PASSWORD"]
    config.env = :test
    config.proxy = ENV["HERMES_API_PROXY"]
  end
end 