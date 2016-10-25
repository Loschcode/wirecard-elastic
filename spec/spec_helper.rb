require "bundler/setup"
Bundler.setup

require "pry"
require "active_support/all"
require "wirecard/elastic"

# wirecard elastic configuration
# Wirecard::Elastic.config do |config|
#
#   config.creditcard = {
#     :username => ENV["wirecard_elastic_api_creditcard_username"],
#     :password => ENV["wirecard_elastic_api_creditcard_password"],
#     :engine_url => ENV["wirecard_elastic_api_creditcard_engine_url"]
#   }
#
#   config.upop = {
#     :username => ENV["wirecard_elastic_api_upop_username"],
#     :password => ENV["wirecard_elastic_api_upop_password"],
#     :engine_url => ENV["wirecard_elastic_api_upop_engine_url"]
#   }
#
# end

# use this to configure anything
# on the wirecard elastic api gem
RSpec.configure do |config|

end
