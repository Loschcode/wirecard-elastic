require 'net/http'

# entry point of the request system
# this is where the API call is produced
module Wirecard
  module Elastic
    class Request

      # content type might be flexible in the future
      # for now it's a simple constant as the API
      # is still simple
      CONTENT_TYPE = 'text/xml'.freeze

      # allowed methods to communicate to the API
      # a get is usually without body
      # a post will be with XML datas transmitted
      ALLOWED_METHODS = [:get, :post]

      # checking of the URL validity via REGEX
      URL_PATTERN = /\A#{URI::regexp(['http', 'https'])}\z/

      attr_reader :method, :body, :query_uri, :payment_method

      # prepare the request datas and check the query URL on the fly
      def initialize(query_uri:, payment_method:, method: :get, body: '')
        @payment_method = payment_method
        @method         = method
        @body           = body
        @query_uri      = query_uri
        raise Wirecard::Elastic::ConfigError, "Invalid engine URL" unless valid_query?
      end

      # process the actual call and return the instance
      # raise an error if the server didn't answer anything
      def dispatch!
        @dispatch ||= begin
          if callback.nil?
            raise Wirecard::Elastic::Error, "The request was not successful"
          else
            self
          end
        end
      end

      # compose the query via configuration and transmitted URI
      def query
        @query ||= "#{gateway[:engine_url]}#{query_uri}.json"
      end

      # get the http raw response from the API
      # it's supposed to be a simple string
      # we might parse as JSON later on
      def callback
        @callback ||= Net::HTTP.start(query_url.host, query_url.port,
        :use_ssl     => https_request?,
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |connection| send(connection) }
      end

      private

      # connect and authenticate
      # the client to the remote API
      def send(connection)
        request.basic_auth gateway[:username], gateway[:password] # authentification here
        request.body         = body # body (XML for instance)
        request.content_type = CONTENT_TYPE # XML
        connection.request request # give a response
      end

      # prepare the request by instanting Net::HTTP::Get/Post
      # and manage it depending on the method
      def request
        @request ||= begin
          if ALLOWED_METHODS.include?(method)
            Net::HTTP.const_get(method.capitalize).new(query_url.request_uri)
          else
            raise Wirecard::Elastic::Error, "Request method not recognized"
          end
        end
      end

      # simple query URL checker
      def valid_query?
        (query =~ URL_PATTERN) != nil
      end

      # encapsulate the query into URI(*)
      def query_url
        @query_url ||= URI(query)
      end

      # check if the request is SSL or not
      def https_request?
        query_url.scheme == 'https'
      end

      # get the details from the configuration
      # will fail if there's no valid configuration
      def gateway
        @gateway ||= begin
          @gateway = Wirecard::Elastic.configuration.instance_variable_get("@#{payment_method}")
          if @gateway.nil?
            raise Wirecard::Elastic::Error, "Can't recover #{payment_method} details. Please check your configuration."
          else
            @gateway
          end
        end
      end

    end
  end
end
