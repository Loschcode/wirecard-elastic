# build the template, this system is type agnostic
# which means any type of file could be output from this point
module Wirecard
  module Elastic
    class Request
      module Body
        class Builder

          attr_reader :origin, :template

          # set the template and the origin instance
          # the origin will be used to setup the params
          # by using the different datas of the class asking
          # for a body content
          def initialize(origin, template)
            @origin   = origin
            @template = template
          end

          # conversion into XML format
          def to_xml
            Xml.new(template, params).build!
          end

          # generation of the parameters used in the template
          # through the origin instance
          def params
            Params.const_get(template.capitalize).new(origin).deliver!
          end

        end
      end
    end
  end
end
