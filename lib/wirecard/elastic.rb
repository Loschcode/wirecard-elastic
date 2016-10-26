Dir[File.expand_path "lib/**/*.rb"].each { |file| require_relative(file) }

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
