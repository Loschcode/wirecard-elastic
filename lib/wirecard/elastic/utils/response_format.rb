require 'rexml/text'

# format the response and handle / convert the result hash
# it's used throughout the whole ElasticApi library when a `response`
# has to be returned
module Wirecard
  class ElasticApi
    module Utils
      class ResponseFormat

        # will force symbol conversion for those specific methods calls
        # *method.status will return a symbol
        # *method.anything will return the raw value
        # NOTE : `transaction_type` isn't here because we don't want to turn `refund-purchase` into `refund_purchase`
        # we use UNDERSCORE_MAP for that
        SYMBOLS_MAP = [:request_status, :transaction_type, :transaction_state, :payment_method]
        UNDERSCORE_MAP = [:request_status, :transaction_state, :payment_method]
        attr_reader :origin, :raw

        # .to_call will convert the `method_name` into
        # the raw method matching to it and sybmolize
        class << self
          def to_call(method_name)
            "raw_#{method_name}".to_sym
          end
        end

        def initialize(origin, raw)
          @origin = origin
          @raw = raw
        end

        # we are calling the different raw_* methods
        # if someone tries to access an unknown method
        # it can also convert some strings responses
        # into symbols on the way
        # TODO : could be refactored (chaining if are bad.)
        def method_missing(method_symbol, *arguments, &block)
          to_call = ResponseFormat.to_call(method_symbol)
          if self.respond_to?(to_call)
            response = self.send(to_call)
            if SYMBOLS_MAP.include?(method_symbol)
              if UNDERSCORE_MAP.include?(method_symbol)
                symbolize_data(underscore_data(response))
              else
                symbolize_data(response)
              end
            else
              response
            end
          end
        end

        def raw_request_id; cycle(:"request-id"); end
        def raw_request_status; cycle(:statuses, :status, 0, :severity); end
        def raw_requested_amount; cycle(:"requested-amount", :value); end
        # raw_currency original
        def raw_requested_amount_currency; cycle(:"requested-amount", :currency); end
        def raw_transaction_id; cycle(:"transaction-id"); end
        def raw_transaction_type; cycle(:"transaction-type"); end
        # raw_status originaly (TO TEST A LOT BEFORE TO REMOVE THIS COMMENT)
        def raw_transaction_state; cycle(:"transaction-state"); end
        def raw_payment_method; cycle(:"payment-methods", :"payment-method", 0, :name); end

        private

        # cool method to try to go through a hash, could be WAY improved
        # but who got time for that ?
        def cycle(*elements)
          position = raw[:payment] || raw[:payment]&.[](:"merchant-account-id")
          elements.each do |element|
            position = position&.[](element)
            return position if position.nil?
          end
          position
        end

        # convert the data to a symbol
        def symbolize_data(data)
          data.to_s.to_sym
        end

        def underscore_data(data)
          data.to_s.gsub("-", "_")
        end

      end
    end
  end
end
