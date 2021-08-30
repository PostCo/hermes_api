require "dotenv/load"

def set_config
  HermesAPI.configure do |config|
    config.env = :production
    config.proxy = ENV["HERMES_API_PROXY"]
  end
end
