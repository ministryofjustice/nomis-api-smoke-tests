require 'uri'
require 'net/http'

require 'nomis/api/request'

module NOMIS
  module API
    # Convenience wrapper around an API call
    # Manages defaulting of params from env vars,
    # and parsing the returned JSON
    class Get
      include NOMIS::API::Request

      protected

      def prepare_request
        uri = URI.join(base_url, path)
        uri.query = URI.encode_www_form(params)

        req = Net::HTTP::Get.new(uri)
        required_headers.each { |name, value| req[name] = value }
        
        req
      end
    end
  end
end