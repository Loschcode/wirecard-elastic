require 'rexml/text'

# format the response and handle / convert the result hash
# it's used throughout the whole ElasticApi library when a `response`
# has to be returned
module Wirecard
  module Elastic
    class Response
      class Base

        # will force symbol conversion for those specific methods calls
        # *method.transaction_state will return a symbol
        # *method.anything will return the raw value from the API
        SYMBOLS_MAP    = [:request_status, :transaction_type, :transaction_state, :payment_method]

        # `transaction_type` isn't here because we don't want
        # to turn `refund-purchase` into `refund_purchase`
        # we use UNDERSCORE_MAP for that
        UNDERSCORE_MAP = [:request_status, :transaction_state, :payment_method]

        attr_reader :origin, :raw

        def initialize(origin, raw)
          @origin = origin
          @raw    = raw
        end

        def method_missing(method_symbol, *arguments, &block)
          if map.include?(method_symbol)
            response = cycle(*map[method_symbol])
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

        # general mapping for automatic method recovery
        # when you basically ask for MyResponse.request_id it will go through the hash
        # following the map and return the value at the end of the loop
        # each response class can extend easily the map for its own specific use
        def map
          {
            :request_id                => [:"request-id"],
            :request_status            => [:statuses, :status, 0, :severity],
            :requested_amount          => [:"requested-amount", :value],
            :requested_amount_currency => [:"requested-amount", :currency],
            :transaction_id            => [:"requested-id"],
            :transaction_type          => [:"transaction-type"],
            :transaction_state         => [:"transaction-state"],
            :payment_method            => [:"payment-methods", :"payment-method", 0, :name]
          }
        end

        private

        # navigate through the hash without crashing
        def cycle(*elements)
          position = raw[:payment] || raw[:payment]&.[](:"merchant-account-id")
          elements.each do |element|
            position = position&.[](element)
            return position if position.nil?
          end
          position
        end

        # convert the data into a symbol
        def symbolize_data(data)
          data.to_s.to_sym
        end

        # convert - into _
        def underscore_data(data)
          data.to_s.gsub("-", "_")
        end

      end
    end
  end
end
