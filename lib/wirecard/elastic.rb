Dir[File.expand_path "lib/**/*.rb"].each { |file| require_relative(file) }

module Wirecard
  module Elastic

    METHODS_MAP = [:transaction, :refund]

    class << self
      
      def method_missing(method, *args)
        raise Error, "Invalid method" unless METHODS_MAP.include?(method)
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
