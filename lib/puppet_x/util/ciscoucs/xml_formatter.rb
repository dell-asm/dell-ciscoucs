require 'pathname'
require 'rexml/document'

cisco_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
#require File.join vmware_module.path, 'lib/puppet_x/vmware/util'

module_lib = Pathname.new(__FILE__).parent.parent.parent

#require 'set'

class  Puppet_X::Util::Ciscoucs::Xml_formatter
  def initialize(command_name)
    @command = command_name
  end

  def command_xml (attributes)
    update_xml attributes
  end

  private

  def xml_template_path
    #File.join cisco_module.path, 'lib/puppet_x/ciscoucs/util/xml'
    path= '/etc/puppetlabs/puppet/modules/ciscoucs/lib/puppet_x/util/ciscoucs/xml'

  end

  def xml_template
    content = ""
    xml_path = File.join xml_template_path, @command
    xml_path+= ".xml"
    if File.exists?(xml_path)
      # read file in block will close the file handle internally when block terminates
      content = File.open(xml_path, 'r') { |file| file.read }
    else
      #      Puppet::Error "Cannot read request xml template at location: " + xml_path
      puts "no file to read"
    end
    return content
  end

  def update_xml (parameters)
    xml_content = xml_template
    if xml_content != ""
      doc = REXML::Document.new(xml_content)
      r = doc.root
      # get attributes
      if parameters.kind_of?(Hash)
        parameters.keys.each do |node_path, value|
          if parameters[node_path].kind_of?(Hash)
            parameters[node_path].each do |attribute_name, attribute_value|
              # search xpath in xml file and add attribute name and value
              r.elements[node_path].attributes[attribute_name.to_s]= attribute_value.to_stribute[attribute_name]
            end
          end
        end
      end
      doc.write
    end
  end
  
  
  
  
  
end

