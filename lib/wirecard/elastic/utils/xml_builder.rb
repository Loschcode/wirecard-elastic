require 'rexml/text'

# build a XML from a template and some variables
# output a string
module Wirecard
  class ElasticApi
    module Utils
      class XmlBuilder

        attr_reader :template_name, :request

        # template_name is contained in /templates/
        # the request matches the variables to convert (in hash) e.g. :refund
        def initialize(template_name, request)
          @template_name = template_name
          @request = request
        end

        # actually convert the file into a full XML with processed variables
        def to_xml
          xml_template = File.open template_path, "r:UTF-8", &:read
          xml_template.gsub(/{{\w+}}/, request_params)
        end

        private

        def request_params
          request.each_with_object({}) do |(k,v), h|
            h["{{#{k.upcase}}}"] = REXML::Text.new(v.to_s)
          end
        end

        def template_path
          File.expand_path "../../templates/#{template_file}", __FILE__
        end

        def template_file
          "#{template_name}.xml"
        end

      end
    end
  end
end
