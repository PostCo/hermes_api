module HermesAPI
  mattr_accessor :cache

  self.cache = if defined?(Rails) && Rails.respond_to?(:cache) &&
                  Rails.cache.is_a?(ActiveSupport::Cache::Store)
    Rails.cache
  else
    ActiveSupport::Cache::MemoryStore.new
  end
end