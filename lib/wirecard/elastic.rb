# we load the classes
require 'wirecard/elastic/request/body/builder/xml'
require 'wirecard/elastic/request/body/params/refund'
require 'wirecard/elastic/request/body/builder'
require 'wirecard/elastic/request/base'
require 'wirecard/elastic/request/refund'
require 'wirecard/elastic/request/transaction'
require 'wirecard/elastic/response/base'
require 'wirecard/elastic/response/refund'
require 'wirecard/elastic/response/transaction'
require 'wirecard/elastic/configuration'
require 'wirecard/elastic/error'
require 'wirecard/elastic/request'
require 'wirecard/elastic/response'
require 'wirecard/elastic/version'

# this is the entry point of the gem, here goes the configuration system
# also the different methods that should be publicly called
# such as Wirecard::Elastic.transaction(*) or Wirecard::Elastic.refund(*)
module Wirecard
  module Elastic

    # this restrict the actions available via the library to avoid crashes
    # adding `:whatever` will allow to call Elastic.whatever
    # and try to load Request::Whatever.new(*args) with it
    METHODS_MAP = [:transaction, :refund]

    class << self

      def method_missing(method, *args)
        unless METHODS_MAP.include?(method)
          raise Error, "Invalid action. Please use the methods available (#{METHODS_MAP.join(', ')})"
        end
        Request.const_get(method.capitalize).new(*args)
      end

      # access and define configuration
      # this is used while loading
      # your environment (initializers)
      def configuration
        @configuration ||= Configuration.new
        if block_given?
          yield @configuration
        else
          @configuration
        end
      end

      alias :config :configuration

      # simply reset the configuration
      # NOTE : avoid to use this if you're
      # not resetting anything afterwards
      def reset
        @configuration = Configuration.new
      end

    end
  end
end
