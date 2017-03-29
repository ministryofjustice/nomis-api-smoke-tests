require 'base64'
require 'jwt'
require 'openssl'

module NOMIS
  module API
    # Encapsulates the process of generating a bearer token for the API gateway
    class AuthToken
      attr_accessor :client_token, :client_key, :iat_fudge_factor

      # iat_fudge_factor lets you correct for time drift on the target server
      # for instance, if the server time is more than 10s in the future,
      # it will reject any client-generated bearer tokens on the grounds of
      # 'iat skew too large'
      # (basically, your timestamp in your payload is too old)
      # In that case, you can pass an iat_fudge_factor of, say, 5, to generate a
      # timestamp tagged 5s into the future and bring it back within the
      # acceptable range.
      # Yes, this is a fudge until we get proper NNTP set up on the VMs
      def initialize(params = {})
        self.client_key = OpenSSL::PKey::EC.new(
          params[:client_key] || default_client_key(params)
        )
        self.client_token = params[:client_token] \
                          || default_client_token(params)

        self.iat_fudge_factor = default_iat_fudge_factor
      end

      def bearer_token
        validate_keys!

        auth_token = JWT.encode(payload, client_key, 'ES256')

        "Bearer #{auth_token}"
      end

      def payload
        {
          iat: Time.now.to_i + iat_fudge_factor,
          token: client_token
        }
      end

      # Validate that the supplied private key matches the token's public key.
      # Obviously this step is optional, but when testing locally it's
      # easy to get one's private keys in a muddle, and the API gateway's
      # error message can only say that the generated JWT token does not
      # validate.
      def validate_keys!
        client_pub = OpenSSL::PKey::EC.new client_key
        client_pub.private_key = nil
        client_pub_b64 = Base64.strict_encode64(client_pub.to_der)

        expected_client_pub = JWT.decode(client_token, nil, nil)[0]['key']

        raise bad_private_key_error unless client_pub_b64 == expected_client_pub
      end

      protected

      def bad_private_key_error
        'Incorrect private key supplied ' \
                + '(does not match public key within token)'
      end

      def default_client_key(params = {})
        read_client_key_file(params[:client_key_file] \
          || ENV['NOMIS_API_CLIENT_KEY_FILE'])
      end
      
      def default_client_token(params = {})
        read_client_key_file(params[:client_token_file] \
          || ENV['NOMIS_API_CLIENT_TOKEN_FILE'])
      end

      def default_iat_fudge_factor
        ENV['NOMIS_API_IAT_FUDGE_FACTOR'].to_i || 0
      end

      def read_client_token_file(path)
        File.open(File.expand_path(path), 'r').read.chomp('')
      end

      def read_client_key_file(path)
        File.open(File.expand_path(path), 'r').read
      end

    end
  end
end