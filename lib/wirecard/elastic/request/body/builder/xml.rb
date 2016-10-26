require 'rexml/text'

# build a XML from a template and some variables
# output a string to be transmitted to the API
module Wirecard
  module Elastic
    class Request
      module Body
        class Builder
          class Xml

            TEMPLATE_FORMAT = "UTF-8".freeze
            TEMPLATE_PATH   = "../../templates/".freeze

            attr_reader :template_name, :request

            # template_name is contained in /templates/
            # the request matches the variables to convert (in hash) e.g. :refund
            def initialize(template_name, request)
              @template_name = template_name
              @request       = request
            end

            # actually convert the file into a full XML with processed variables
            def build!
              xml_template = File.open(template_path, "r:#{TEMPLATE_FORMAT}", &:read)
              xml_template.gsub(/{{\w+}}/, request_params)
            end

            private

            # convert the current {{VARIABLES}}
            # into their real values
            def request_params
              request.each_with_object({}) do |(key,value), hash|
                hash["{{#{key.upcase}}}"] = REXML::Text.new(value.to_s)
              end
            end

            def template_path
              File.expand_path "#{TEMPLATE_PATH}#{template_file}", __FILE__
            end

            def template_file
              "#{template_name}.xml"
            end

          end
        end
      end
    end
  end
end
