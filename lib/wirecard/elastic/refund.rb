# refund a customer via the API
# this will make a double API call
# to first recover the original payment transaction
module Wirecard
  module Elastic
    class Refund < Base

      REQUEST_IP_ADDRESS = "127.0.0.1".freeze
      REFUND_MAP = {:purchase => :'refund-purchase', :debit => :'refund-debit'}.freeze

      attr_reader :merchant_id, :parent_transaction_id, :request_id, :payment_method

      def initialize(merchant_id, parent_transaction_id, payment_method)
        @merchant_id = merchant_id
        @parent_transaction_id = parent_transaction_id
        @request_id = SecureRandom.uuid
        @payment_method = payment_method
      end

      # process the query response
      # return the response format
      def response
        @response ||= begin
          response = Wirecard::Elastic::Utils::Request.new(query, payment_method, :post, body).response
          if response.nil?
            raise Wirecard::Elastic::Error, "The refund was not processed"
          else
            Utils::ResponseFormat.new(self, response)
          end
        end
      end

      # query URI to the API
      def query
        if parent_transaction.response.transaction_type == :purchase
          @query ||= "payments"
        elsif parent_transaction.response.transaction_type == :debit
          @query ||= "paymentmethods"
        end
      end

      # XML body we will send to the elastic API
      def body
        @body ||= Elastic::Utils::XmlBuilder.new(:refund, body_params).to_xml
      end

      private

      # params we will use to fill the XML format request
      def body_params
        {
          :merchant_account_id => merchant_id,
          :request_id => request_id,
          :parent_transaction_id => parent_transaction_id,
          :ip_address => REQUEST_IP_ADDRESS
        }.merge(remote_params)
      end

      # get some body params from the remote elastic API itslef rather than our database (safer)
      def remote_params
        {
          :currency => parent_transaction.response.requested_amount_currency,
          :amount => parent_transaction.response.requested_amount,
          # potential bug because it's a symbol ?
          :payment_method => parent_transaction.response.payment_method,
          :transaction_type => refund_transaction_type
        }
      end

      def refund_transaction_type
        REFUND_MAP[parent_transaction.response.transaction_type]
      end

      # original transaction of the refund, requested remotely to elastic API
      def parent_transaction
        @parent_transaction ||= Wirecard::Elastic::Transaction.new(merchant_id, parent_transaction_id, payment_method)
      end

    end
  end
end
