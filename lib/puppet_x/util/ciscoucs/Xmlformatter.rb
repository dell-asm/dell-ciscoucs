require 'rexml/document'

module  PuppetX
  module Util
    module Ciscoucs
      class Xmlformatter
        def initialize(command_name)
          @command = command_name
        end

        def command_xml (attributes)
          update_xml attributes
        end

        private

        def xml_template_path
          module_lib = Pathname.new(__FILE__).parent.parent.parent
          File.join module_lib.to_s, '/util/ciscoucs/xml'

        end

        def xml_template
          content = ""
          xml_path = File.join xml_template_path, @command
          xml_path+= ".xml"
          if File.exists?(xml_path)
            # read file in block will close the file handle internally when block terminates
            content = File.open(xml_path, 'r') { |file| file.read }
          else
            raise Puppet::Error, "Cannot read request xml template from location: " + xml_path
          end
          return content
        end

        def update_xml (parameters)
          xml_content = xml_template

          if xml_content.to_s.strip.length == 0
            raise Puppet::Error, "Empty xml template found for " + @command + " operation"
          end

          begin
            doc = REXML::Document.new(xml_content.to_s)
            doc.context[:attribute_quote] = :quote
            r = doc.root
            # get attributes
            if parameters.kind_of?(Hash)
              parameters.keys.each do |node_path, value|
                if parameters[node_path].kind_of?(Hash)
                  parameters[node_path].each do |attribute_name, attribute_value|
                    # search xpath in xml file and add attribute name and value
                    elem = r.elements[node_path]
                    elem.attributes[attribute_name.to_s] = attribute_value.to_s
                  end
                end
              end
            end
            doc.to_s
          rescue Exception => msg
            raise Puppet::Error, "Following error occurred while parsing " + @command + ".xml: " +  msg.to_s
          end
        end

      end
    end
  end
end
