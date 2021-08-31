module HermesAPI
  mattr_accessor :cache

  self.cache = ActiveSupport::Cache::MemoryStore.new
end
