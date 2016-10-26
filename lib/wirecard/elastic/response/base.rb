require 'rexml/text'

# format the response and handle / convert the result hash
# it's used throughout the whole ElasticApi library when a `response`
# has to be returned
module Wirecard
  module Elastic
    class Response
      class Base

        # will force symbol conversion for those specific methods calls
        # *method.status will return a symbol
        # *method.anything will return the raw value
        # NOTE : `transaction_type` isn't here because we don't want to turn `refund-purchase` into `refund_purchase`
        # we use UNDERSCORE_MAP for that
        SYMBOLS_MAP = [:request_status, :transaction_type, :transaction_state, :payment_method]
        UNDERSCORE_MAP = [:request_status, :transaction_state, :payment_method]

        attr_reader :origin, :raw

        def initialize(origin, raw)
          @origin = origin
          @raw = raw
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
