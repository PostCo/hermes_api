require "zeitwerk"
require_relative "config"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "hermes_api" => "HermesAPI"
)
loader.push_dir("./lib")
loader.collapse("./lib/hermes_api/resources")
loader.ignore("#{__dir__}/config.rb")
loader.enable_reloading
# loader.log!
loader.setup

$__hermes_api_loader__ = loader

def reload!
  $__hermes_api_loader__.reload
  set_config
  true
end
