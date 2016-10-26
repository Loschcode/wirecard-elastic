require 'net/http'

# send the request to Wirecard API via authentication
# get the response from it
module Wirecard
  module Elastic
    class Request

      CONTENT_TYPE = 'text/xml'.freeze

      attr_reader :method, :body, :uri_query, :payment_method

      # uri_query gets the URI of request to the API
      # method specify if it has to be a :get or :post
      # body understood by the API is basically XML
      def initialize(uri_query, payment_method, method=:get, body='')
        @payment_method = payment_method
        @method = method
        @body = body
        @uri_query = uri_query
        raise Wirecard::Elastic::ConfigError, "Invalid engine URL" unless valid_query_url?
      end

      def dispatch!
        @dispatch ||= begin
          if raw_response.nil?
            raise Wirecard::Elastic::Error, "The request was not successful"
          else
            self
          end
        end
      end

      def query
        @query ||= "#{access[:engine_url]}#{uri_query}.json"
      end

      # get the http raw response to the API
      # it's supposed to be a string, check out #response to get the hashed version
      def raw_response
        @raw_response ||= Net::HTTP.start(request_uri.host, request_uri.port,
        :use_ssl     => https_request?,
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |connection| send(connection) }
      end

      private

      # connect and authenticate the client to the API server
      def send(connection)
        request.basic_auth access[:username], access[:password] # authentification here
        request.body = body # body (XML for instance)
        request.content_type = CONTENT_TYPE # XML
        connection.request request # give a response
      end

      # prepare the request and manage the differents methods used
      def request
        @request ||= begin
          if method == :get
            Net::HTTP::Get.new(request_uri.request_uri)
          elsif method == :post
            Net::HTTP::Post.new(request_uri.request_uri)
          else
            raise Wirecard::Elastic::Error, "Request method not recognized"
          end
        end
      end

      def valid_query_url?
        (query =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil
      end

      def request_uri
        @request_uri ||= URI(query)
      end

      def https_request?
        request_uri.scheme == 'https'
      end

      def access
        @access ||= begin
          @access = Wirecard::Elastic.configuration.instance_variable_get("@#{payment_method}")
          if @access.nil?
            raise Wirecard::Elastic::Error, "Can't recover #{payment_method} details. Please check your configuration."
          else
            @access
          end
        end
      end

    end
  end
end
