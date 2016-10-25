require "wirecard/elastic/version"
require "wirecard/elastic/configuration"
require "wirecard/elastic/base"
require "wirecard/elastic/transaction"
require "wirecard/elastic/refund"

module Wirecard
  module Elastic

    class << self

      def transaction(merchant_id, transaction_id, payment_method)
        binding.pry
        Transaction.new(merchant_id, transaction_id, payment_method)
      end

      def refund(merchant_id, parent_transaction_id, payment_method)
        Refund.new(merchant_id, parent_transaction_id, payment_method)
      end

      def configuration
        yield Configuration
      end

      alias :config :configuration

    end

  end
end
