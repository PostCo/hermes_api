# frozen_string_literal: true

require_relative "hermes_api/version"
require "active_resource"

module HermesAPI
  require "hermes_api/configuration"
  require "hermes_api/creation_error"
  require "hermes_api/connection"

  require "hermes_api/resources/base"
  require "hermes_api/resources/return_label"
end
