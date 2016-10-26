require "wirecard/elastic/request/body/builder/xml"
require "wirecard/elastic/request/body/builder"
require "wirecard/elastic/request/body/params/refund" # should be dynamically loaded ?
require "wirecard/elastic/request/base"
require "wirecard/elastic/request/refund" # should be dynamically loaded ?
require "wirecard/elastic/request/transaction" # should be dynamically loaded ? -> method missing
require "wirecard/elastic/response/builder"
require "wirecard/elastic/configuration"
require "wirecard/elastic/error"
require "wirecard/elastic/request"
require "wirecard/elastic/response"
require "wirecard/elastic/version"

module Wirecard
  module Elastic

    class << self

      def method_missing(method, *args)
        Request.const_get(method.capitalize).new(*args)
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
