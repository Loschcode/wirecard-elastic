module Wirecard
  module Elastic
    class Request
      class Base

        VALID_STATUS_LIST = [:success, :failed].freeze

        # calling #safe will check if the transaction was successful or/and valid
        # and raise an error if not ; this is a useful shortcut
        # when manipulating the datas at a upper level
        def safe
          raise Wirecard::Elastic::Error, "The status of the transaction is not correct (#{response.request_status})" unless valid_status?
          raise Wirecard::Elastic::Error, "The transaction could not be verified. API access refused." if negative_response?
          self
        end

        alias :raise_response_issues :safe # retro compatibility v0.1.1

        private

        def valid_status?
          VALID_STATUS_LIST.include? response.transaction_state
        end

        def negative_response?
          response.transaction_state == :failed && response.request_status == :error
        end

      end
    end
  end
end
