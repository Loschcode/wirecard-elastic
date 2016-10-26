module Wirecard
  module Elastic
    class Response
      class Transaction < Base

        def map
          {
            :request_id => [:"request-id"],
            :request_status => [:statuses, :status, 0, :severity],
            :requested_amount => [:"requested-amount", :value],
            :requested_amount_currency => [:"requested-amount", :currency],
            :transaction_id => [:"requested-id"],
            :transaction_type => [:"transaction-type"],
            :transaction_state => [:"transaction-state"],
            :payment_method => [:"payment-methods", :"payment-method", 0, :name]
          }
        end

      end
    end
  end
end
