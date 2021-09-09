module HermesAPI
  class JsonBase < ActiveResource::Base
    self.include_format_in_path = false
    self.auth_type = :bearer

    def self.inherited(subclass)
      subclass.extend(BearerAuth)
    end

    def load(attributes, remove_root = false, persisted = false)
      attributes.deep_transform_keys! { |k| k.to_s.underscore }
      super
    end

    def to_json(options = {})
      attributes.as_json.deep_transform_keys { |k| k.to_s.camelize(:lower) }
        .to_json(include_root_in_json ? {root: self.class.element_name}.merge(options) : options)
    end
  end
end
