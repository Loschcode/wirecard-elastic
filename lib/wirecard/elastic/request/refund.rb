# refund a customer via the API
# this will make a double API call
# to first recover the original payment transaction
module Wirecard
  module Elastic
    class Request
      class Refund < Base

        PAYMENT_QUERY_MAP = {:purchase => "payments", :debit => "paymentmethods"}.freeze

        attr_reader :merchant_id, :parent_transaction_id, :request_id, :payment_method

        def initialize(merchant_id, parent_transaction_id, payment_method)
          @merchant_id           = merchant_id
          @parent_transaction_id = parent_transaction_id
          @request_id            = SecureRandom.uuid
          @payment_method        = payment_method
        end

        # process the query response
        # return the response format
        def request
          @request ||= Request.new(query_uri: query, payment_method: payment_method, method: :post, body: body).dispatch!
        end

        def response
          @response ||= Response.new(request: request, action: :refund).dispatch!
        end

        # query URI to the API
        def query
          @query ||= PAYMENT_QUERY_MAP[parent_transaction.response.transaction_type]
        end

        # XML body we will send to the elastic API
        def body
          @body ||= Body::Builder.new(self, :refund).to_xml
        end

        # original transaction of the refund, requested remotely to elastic API
        def parent_transaction
          @parent_transaction ||= Transaction.new(merchant_id, parent_transaction_id, payment_method)
        end

      end
    end
  end
end
