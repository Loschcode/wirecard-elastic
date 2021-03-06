# setup the parameters that will be transmitted to the body builder
# which will convert the template into real values
module Wirecard
  module Elastic
    class Request
      module Body
        module Params
          class Refund

            # the request IP address is for now a static local address
            REQUEST_IP_ADDRESS = "127.0.0.1".freeze

            # each transaction its symetric refund term
            REFUND_MAP         = {:purchase => :'refund-purchase', :debit => :'refund-debit'}.freeze

            attr_reader :origin

            def initialize(origin)
              @origin = origin
            end

            # output the hash
            def deliver!
              local.merge(remote)
            end

            private

            # params we will use to fill the XML format request
            def local
              {
                :merchant_account_id   => origin.merchant_id,
                :request_id            => origin.request_id,
                :parent_transaction_id => origin.parent_transaction_id,
                :ip_address            => REQUEST_IP_ADDRESS
              }
            end

            # get some body params from the remote elastic API itself rather than our database (safer)
            def remote
              {
                :currency         => origin.parent_transaction.response.requested_amount_currency,
                :amount           => origin.parent_transaction.response.requested_amount,
                :payment_method   => origin.parent_transaction.response.payment_method,
                :transaction_type => refund_transaction_type
              }
            end

            def refund_transaction_type
              REFUND_MAP[origin.parent_transaction.response.transaction_type]
            end

          end
        end
      end
    end
  end
end
