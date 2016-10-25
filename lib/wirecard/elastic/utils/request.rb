require 'net/http'

# send the request to Wirecard API via authentication
# get the response from it
module Wirecard
  module Elastic
    module Utils
      class Request

        CONTENT_TYPE = 'text/xml'.freeze

        attr_reader :engine_url, :username, :password, :query, :method, :body, :payment_method

        # uri_query gets the URI of request to the API
        # method specify if it has to be a :get or :post
        # body understood by the API is basically XML
        def initialize(uri_query, payment_method, method=:get, body='')
          @payment_method = payment_method
          @engine_url = access[:engine_url]
          @username = access[:username]
          @password = access[:password]
          @query = "#{engine_url}#{uri_query}.json"
          @method = method
          @body = body
        end

        # get the http raw response to the API
        # it's supposed to be a string, check out #response to get the hashed version
        def raw_response
          @raw_response ||= Net::HTTP.start(request_uri.host, request_uri.port,
                                :use_ssl     => https_request?,
                                :verify_mode => OpenSSL::SSL::VERIFY_NONE) { |connection| dispatch!(connection) }
        end

        # check the body of the response and return it or `nil`
        # NOTE : sometimes the API answers with bullshit like a HTML 404 ERROR
        # so we have to check if the body is valid beforehand
        def response
          @response ||= JSON.parse(raw_response.body).deep_symbolize_keys if valid_body?
        end

        private

        def valid_body?
          raw_response.body && valid_json?(raw_response.body)
        end

        def valid_json?(json)
          JSON.parse(json)
          true
        rescue JSON::ParserError
          false
        end

        # connect and authenticate the client to the API server
        def dispatch!(connection)
          request.basic_auth username, password # authentification here
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
              raise Wirecard::ElasticApi::Error, "Request method not recognized"
            end
          end
        end

        def request_uri
          @request_uri ||= URI(query)
        end

        def https_request?
          request_uri.scheme == 'https'
        end

        private

        def access
          Configuration.class_variable_get("@@#{payment_method}")
        rescue NameError
          raise Wirecard::Elastic::Error, "Can't recover #{payment_method} details. Please check your configuration."
        end

      end
    end
  end
end
