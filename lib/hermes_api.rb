# frozen_string_literal: true

require_relative "hermes_api/version"
require "active_resource"

module HermesAPI
  require "hermes_api/bearer_auth"
  require "hermes_api/cache"
  require "hermes_api/configuration"
  require "hermes_api/connection"
  require "hermes_api/creation_error"

  require "hermes_api/shared/return_label_helper"

  require "hermes_api/resources/base"
  require "hermes_api/resources/drop_off_return_label"
  require "hermes_api/resources/json_base"
  require "hermes_api/resources/o_auth"
  require "hermes_api/resources/pickup_return_label"
  require "hermes_api/resources/print_in_store_qr_code"
  require "hermes_api/resources/tracking_event"
  require "hermes_api/resources/web_tracking"
end
