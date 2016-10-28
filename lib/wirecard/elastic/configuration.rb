# configuration of the gem and
# default values set here
module Wirecard
  module Elastic
    class Configuration

      attr_accessor :creditcard, :upop

      def initialize
        @upop       = { }
        @creditcard = { }
      end

    end
  end
end
