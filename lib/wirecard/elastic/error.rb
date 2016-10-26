# any error occurring from the gem should be
# generated through those classes
module Wirecard
  module Elastic
    class Error < StandardError; end
    class ConfigError < StandardError; end
  end
end
