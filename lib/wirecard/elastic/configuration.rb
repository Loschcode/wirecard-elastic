module Wirecard
  module Elastic
    class Configuration

      attr_accessor :creditcard
      attr_accessor :upop

      def initialize
        @upop       = { }
        @creditcard = { }
      end

    end
  end
end
