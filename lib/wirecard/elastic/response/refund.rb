module Wirecard
  module Elastic
    class Response
      class Refund < Base

          # lots of refund specific mapping can be added below
          # you just have to do `super.merge(whatever)`
          def map
            super.merge({})
          end

      end
    end
  end
end
