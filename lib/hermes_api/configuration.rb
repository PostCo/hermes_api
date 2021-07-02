module HermesAPI
  class Configuration
    attr_accessor :proxy, :env, :user, :password
  end

  PRODUCTION_SITE = "https://www.hermes-europe.co.uk"
  TESTING_SITE = "https://sit.hermes-europe.co.uk"

  def self.config
    @config ||= Configuration.new
  end

  def self.config=(config)
    @config = config
  end

  def self.configure
    yield config

    HermesAPI::Base.site = config.env.to_s == "production" ? PRODUCTION_SITE : TESTING_SITE
  end
end
