require 'nomis/api/auth_token'
require 'nomis/api/parsed_response'


module NOMIS
  module API
    module Request
      attr_accessor :params, :auth_token, :base_url, :path

      def initialize(opts = {})
        self.auth_token = opts[:auth_token] || default_auth_token(opts)
        self.base_url   = opts[:base_url] || ENV['NOMIS_API_BASE_URL']
        self.params = opts[:params]
        self.path = opts[:path]
      end

      def execute
        req = prepare_request

        ParsedResponse.new(response(req))
      end

      protected

      def default_auth_token(params = {})
        ENV['NOMIS_API_AUTH_TOKEN'] || \
          NOMIS::API::AuthToken.new(params).bearer_token
      end

      def required_headers
        {
          'Authorization' => auth_token,
          'Accept' => 'application/json, */*',
          'Content-type' => 'application/json'
        }
      end

      def default_auth_token(params = {})
        ENV['NOMIS_API_AUTH_TOKEN'] || \
          NOMIS::API::AuthToken.new(params).bearer_token
      end

      def response(req)
        http = Net::HTTP.new(req.uri.hostname, req.uri.port)
        http.use_ssl = (req.uri.scheme == 'https')
        http.request(req)
      end
    end
  end
end