module HermesAPI
  class Base < ActiveResource::Base
    self.format = :xml
    self.include_format_in_path = false
    self.connection_class = Connection

    headers["Content-Type"] = "text/xml"

    class << self
      def root
        nil
      end

      def with_session(user, password)
        existing_user = self.user
        existing_password = self.password
        self.user = user
        self.password = password
        yield
        self.user = existing_user
        self.password = existing_password
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
