module Wirecard
  module Elastic
    class Request
      module Body
        class Builder

          attr_reader :origin, :template

          def initialize(origin, template)
            @origin   = origin
            @template = template
          end

          def to_xml
            Xml.new(template, params).build!
          end

          def params
            Params.const_get(template.capitalize).new(origin).deliver!
          end

        end
      end
    end
  end
end
