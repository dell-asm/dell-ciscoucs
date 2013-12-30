require 'pathname'
require 'rexml/document'

cisco_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
module_lib = Pathname.new(__FILE__).parent.parent.parent

module  PuppetX
  module Util
    module Ciscoucs
      class Xml_formatter
        def initialize(command_name)
          @command = command_name
        end

        def command_xml (attributes)
          update_xml attributes
        end

        private

        def xml_template_path
          cisco_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
          File.join cisco_module.path, 'lib/puppet_x/util/ciscoucs/xml'

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

          doc = REXML::Document.new(xml_content.to_s)
          doc.context[:attribute_quote] = :quote
          r = doc.root
          # TODO: add begin-rescue
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
        end

      end
    end
  end
end
