require "bundler/setup"
Bundler.setup

require "pry"
require "active_support/all"
require "wirecard/elastic"

# use this to configure anything
# on the wirecard elastic api gem
RSpec.configure do |rspec_config|

  rspec_config.before(:all) do

    # here's a simple list of test datas we will use throughout all the tests
    # this library don't allow payments because we use their HPP
    # therefore I had to generate all of that beforehand
    MERCHANT_UPOP = "dfc3a296-3faf-4a1d-a075-f72f1b67dd2a".freeze unless defined?(MERCHANT_UPOP)
    TRANSACTION_UPOP = "6bbaa57c-8e36-47de-8035-10121256d39b".freeze unless defined?(TRANSACTION_UPOP)
    PAYMENT_METHOD_UPOP = :upop.freeze unless defined?(PAYMENT_METHOD_UPOP)

    MERCHANT_CREDITCARD = "9105bb4f-ae68-4768-9c3b-3eda968f57ea".freeze unless defined?(MERCHANT_CREDITCARD) # NON 3D
    TRANSACTION_CREDITCARD = "60edf310-ce53-473f-9a65-c292d2947328".freeze unless defined?(TRANSACTION_CREDITCARD)
    PAYMENT_METHOD_CREDITCARD = :creditcard.freeze unless defined?(PAYMENT_METHOD_CREDITCARD)

    # here are the test credentials provided by wirecard
    # for the different payments solutions
    # those datas not being sensitive
    # I decided not to hide them in environment variables
    # since they are basically public
    CREDITCARD_USERNAME = "70000-APILUHN-CARD".freeze unless defined?(CREDITCARD_USERNAME)
    CREDITCARD_PASSWORD = "8mhwavKVb91T".freeze unless defined?(CREDITCARD_PASSWORD)
    CREDITCARD_ENGINE_URL = "https://api-test.wirecard.com/engine/rest/".freeze unless defined?(CREDITCARD_ENGINE_URL)
    UPOP_USERNAME = "engine.digpanda".freeze unless defined?(UPOP_USERNAME)
    UPOP_PASSWORD = "x3Zyr8MaY7TDxj6F".freeze unless defined?(UPOP_PASSWORD)
    UPOP_ENGINE_URL = "https://sandbox-engine.thesolution.com/engine/rest/".freeze unless defined?(UPOP_ENGINE_URL)

    Wirecard::Elastic.config do |config|

      config.creditcard = {
        :username => CREDITCARD_USERNAME,
        :password => CREDITCARD_PASSWORD,
        :engine_url => CREDITCARD_ENGINE_URL
      }

      config.upop = {
        :username => UPOP_USERNAME,
        :password => UPOP_PASSWORD,
        :engine_url => UPOP_ENGINE_URL
      }

    end

  end
end
