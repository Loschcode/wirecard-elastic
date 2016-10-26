module Wirecard
  module Elastic
    class Response

      attr_reader :request, :action

      def initialize(request:, action:)
        @request = request
        @action = action
      end

      def dispatch!
        if response.nil?
          raise Wirecard::Elastic::Error, "The request failed."
        else
          Wirecard::Elastic::Response.const_get(action.capitalize).new(request, response)
        end
      end

      def response
        @response ||= JSON.parse(request.callback.body).deep_symbolize_keys if valid_body?
      end

      private

      def valid_body?
        request.callback.body && valid_json?(request.callback.body)
      end

      def valid_json?(json)
        JSON.parse(json)
        true
      rescue JSON::ParserError
        false
      end

    end
  end
end
