module HermesAPI
  class Base < ActiveResource::Base
    self.format = :xml
    # self.connection_class = HermesAPI::Connection
    self.include_format_in_path = false
    self.proxy = HermesAPI.config.proxy
    puts HermesAPI.config.proxy
    self.user = HermesAPI.config.user
    self.password = HermesAPI.config.password
    headers["Content-Type"] = "text/xml"

    class << self
      def root
        nil
      end

      def with_session(user, password)
        self.user = user
        self.password = password
        yield
        self.user = HermesAPI.config.user
        self.password = HermesAPI.config.password
      end
    end

    def initialize(attributes = {}, persisted = false)
      if defined?(self.class::DEFAULT_ATTRS)
        attributes = self.class::DEFAULT_ATTRS.merge(attributes)
      end
      super
    end

    def to_xml(options = {})
      super({root: self.class.root}.merge(options))
    end
  end
end
