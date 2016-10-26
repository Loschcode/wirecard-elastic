module Wirecard
  module Elastic
    class Base

      def dispatch_request!(*args)
        @response ||= begin
          response = Utils::Request.new(*args).response
          if response.nil?
            raise Wirecard::Elastic::Error, "The request was not successful"
          else
            Utils::ResponseFormat.new(self, response)
          end
        end
      end

    end
  end
end
