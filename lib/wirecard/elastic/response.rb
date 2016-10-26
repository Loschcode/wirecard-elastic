# after the request comes the processing of the response
# it checks the actual feedback from the API and react accordingly
module Wirecard
  module Elastic
    class Response

      attr_reader :request, :action

      def initialize(request:, action:)
        @request = request
        @action = action
      end

      # check the response and parse it if possible via JSON
      # transmit the process to one of the Response subclasses (e.g. Refund, Transaction)
      def dispatch!
        if response.nil?
          raise Wirecard::Elastic::Error, "The request failed."
        else
          Wirecard::Elastic::Response.const_get(action.capitalize).new(request, response)
        end
      end

      # process the API feedback by converting it into JSON
      def response
        @response ||= JSON.parse(request.feedback.body).deep_symbolize_keys if valid_body?
      end

      private

      # is the API feedback valid ?
      def valid_body?
        request.feedback.body && valid_json?(request.feedback.body)
      end

      # check it's a parsable JSON
      def valid_json?(json)
        JSON.parse(json)
        true
      rescue JSON::ParserError
        false
      end

    end
  end
end
