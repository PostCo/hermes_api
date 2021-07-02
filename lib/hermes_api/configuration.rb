module HermesAPI
  class Configuration
    attr_accessor :proxy, :env, :user, :password
  end

  PRODUCTION_SITE = "https://www.hermes-europe.co.uk"
  TESTING_SITE = "https://sit.hermes-europe.co.uk"

  class << self
    def config
      @config ||= Configuration.new
    end

    def after_configure
      HermesAPI::Base.site = config.env.to_s == "production" ? PRODUCTION_SITE : TESTING_SITE
      HermesAPI::Base.proxy = config.proxy
      HermesAPI::Base.user = config.user
      HermesAPI::Base.password = config.password
    end

    def configure
      yield config

      after_configure
    end
  end
end
