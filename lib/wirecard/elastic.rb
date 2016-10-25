require "wirecard/elastic/version"
require "wirecard/elastic/error"
require "wirecard/elastic/configuration"
require "wirecard/elastic/base"
require "wirecard/elastic/transaction"
require "wirecard/elastic/refund"
require "wirecard/elastic/utils/request"
require "wirecard/elastic/utils/response_format"
require "wirecard/elastic/utils/xml_builder"

module Wirecard
  module Elastic

    class << self

      def transaction(merchant_id, transaction_id, payment_method)
        Transaction.new(merchant_id, transaction_id, payment_method)
      end

      def refund(merchant_id, parent_transaction_id, payment_method)
        Refund.new(merchant_id, parent_transaction_id, payment_method)
      end

      def configuration
        @configuration ||= Configuration.new
        if block_given?
          yield @configuration
        else
          @configuration
        end
      end

      def reset
        @configuration = Configuration.new
      end

      alias :config :configuration

    end

  end
end
