module HermesAPI
  class Connection < ActiveResource::Connection
    def request(method, path, *arguments)
      result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
        payload[:method] = method
        payload[:request_uri] = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
        # TODO: Figure out why the headers set in the Base class are not being set here
        arguments.last["Content-Type"] = "text/xml"
        payload[:result] = http.send(method, path, *arguments)
        payload[:result]
      end

      raise HermesAPI::CreationError, result if result.body.include?("errorMessages")

      handle_response(result)
    rescue Timeout::Error => e
      raise TimeoutError, e.message
    rescue OpenSSL::SSL::SSLError => e
      raise SSLError, e.message
    end
  end
end
