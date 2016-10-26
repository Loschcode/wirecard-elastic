module Wirecard
  module Elastic
    class Response
      class Transaction < Base

          # lots of transaction specific mapping can be added below
          # you just have to do `super.merge(whatever)`
          def map
            super.merge({})
          end

      end
    end
  end
end
