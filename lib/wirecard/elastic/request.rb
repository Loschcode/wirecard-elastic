require 'net/http'

# send the request to Wirecard API via authentication
# get the response from it
module Wirecard
  module Elastic
    class Request

      CONTENT_TYPE = 'text/xml'.freeze
      ALLOWED_METHODS = [:get, :post]
      URL_PATTERN = /\A#{URI::regexp(['http', 'https'])}\z/

      attr_reader :method, :body, :query_uri, :payment_method

      # query_uri gets the URI of request to the API
      # method specify if it has to be a :get or :post
      # body understood by the API is basically XML
      def initialize(query_uri:, payment_method:, method: :get, body: '')
        @payment_method = payment_method
        @method         = method
        @body           = body
        @query_uri      = query_uri
        raise Wirecard::Elastic::ConfigError, "Invalid engine URL" unless valid_query?
      end

      def dispatch!
        @dispatch ||= begin
          if callback.nil?
            raise Wirecard::Elastic::Error, "The request was not successful"
          else
            self
          end
        end
      end

      def query
        @query ||= "#{access[:engine_url]}#{query_uri}.json"
      end

      # get the http raw response to the API
      # it's supposed to be a string, check out #response to get the hashed version
      def callback
        @callback ||= Net::HTTP.start(query_url.host, query_url.port,
        :use_ssl     => https_request?,
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |connection| send(connection) }
      end

      private

      # connect and authenticate the client to the API server
      def send(connection)
        request.basic_auth access[:username], access[:password] # authentification here
        request.body         = body # body (XML for instance)
        request.content_type = CONTENT_TYPE # XML
        connection.request request # give a response
      end

      # prepare the request and manage the differents methods used
      def request
        @request ||= begin
          if ALLOWED_METHODS.include?(method)
            Net::HTTP.const_get(method.capitalize).new(query_url.request_uri)
          else
            raise Wirecard::Elastic::Error, "Request method not recognized"
          end
        end
      end

      def valid_query?
        (query =~ URL_PATTERN) != nil
      end

      def query_url
        @query_url ||= URI(query)
      end

      def https_request?
        query_url.scheme == 'https'
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
