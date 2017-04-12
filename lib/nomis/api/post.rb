require 'uri'
require 'net/http'

require 'nomis/api/request'

module NOMIS
  module API
    # Convenience wrapper around an API call
    # Manages defaulting of params from env vars,
    # and parsing the returned JSON
    class Post
      include NOMIS::API::Request

      protected

      def prepare_request
        uri = URI.join(base_url, path)

        req = Net::HTTP::Post.new(uri)
        required_headers.each { |name, value| req[name] = value }
        req.body = params.to_json
        req
      end
    end
  end
end