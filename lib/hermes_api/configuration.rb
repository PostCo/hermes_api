module HermesAPI
  class Configuration
    attr_accessor :proxy, :env
  end

  PRODUCTION_SITE = "https://www.hermes-europe.co.uk"
  TESTING_SITE = "https://sit.hermes-europe.co.uk"

  OAUTH_PRODUCTION_SITE = "https://hermes-client-integration-prod.eu.auth0.com"
  OAUTH_TESTING_SITE = "https://hermes-client-integration-pre.eu.auth0.com"

  JSON_PRODUCTION_SITE = "https://api.hermesworld.co.uk"
  # temporarily disabled until it is fixed
  # JSON_TESTING_SITE = "https://hermeslive-pre-prod.apigee.net"
  JSON_TESTING_SITE = JSON_PRODUCTION_SITE

  class << self
    def config
      @config ||= Configuration.new
    end

    def after_configure
      HermesAPI::Base.site = config.env.to_s == "production" ? PRODUCTION_SITE : TESTING_SITE
      HermesAPI::Base.proxy = config.proxy

      HermesAPI::JsonBase.site = config.env.to_s == "production" ? JSON_PRODUCTION_SITE : JSON_TESTING_SITE
      HermesAPI::OAuth.site = config.env.to_s == "production" ? OAUTH_PRODUCTION_SITE : OAUTH_TESTING_SITE
    end

    def configure
      yield config

      after_configure
    end
  end
end
