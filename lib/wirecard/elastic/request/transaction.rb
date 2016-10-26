# recover a transaction details from the Wirecard API
module Wirecard
  module Elastic
    class Request
      class Transaction < Base
        
        VALID_STATUS_LIST = [:success, :failed].freeze

        attr_reader :merchant_id, :transaction_id, :payment_method

        def initialize(merchant_id, transaction_id, payment_method)
          @merchant_id    = merchant_id
          @transaction_id = transaction_id
          @payment_method = payment_method
        end

        def request
          @request ||= Request.new(query_uri: query, payment_method: payment_method).dispatch!
        end

        def response
          @response ||= Response.new(request: request, action: :transaction).dispatch!
        end

        def query
          @query ||= "merchants/#{merchant_id}/payments/#{transaction_id}"
        end

      end
    end
  end
end
