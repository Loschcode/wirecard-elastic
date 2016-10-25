require "bundler/setup"
Bundler.setup

require "pry"
require "active_support/all"
require "wirecard/elastic"

# use this to configure anything
# on the wirecard elastic api gem
RSpec.configure do |rspec_config|

  rspec_config.before(:all) do
    # here are the test credentials provided by wirecard
    # for the different payments solutions
    # those datas not being sensitive
    # I decided not to hide them in environment variables
    # since they are basically public
    Wirecard::Elastic.config do |config|

      config.creditcard = {
        :username => "70000-APILUHN-CARD",
        :password => "8mhwavKVb91T",
        :engine_url => "https://api-test.wirecard.com/engine/rest/"
      }

      config.upop = {
        :username => "engine.digpanda",
        :password => "x3Zyr8MaY7TDxj6F",
        :engine_url => "https://sandbox-engine.thesolution.com/engine/rest/"
      }

    end

  end
end
