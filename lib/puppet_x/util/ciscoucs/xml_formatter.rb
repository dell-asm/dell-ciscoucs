require 'pathname'

cisco_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
#require File.join vmware_module.path, 'lib/puppet_x/vmware/util'

module_lib = Pathname.new(__FILE__).parent.parent.parent

#require 'set'

class  Puppet_X::Util::Ciscoucs::Xml_formatter
  def initialize(command_name)
    @command = command_name
  end

  def xml_template_path
    File.join cisco_module.path, 'lib/puppet_x/ciscoucs/util/xml'
  end

  def xml_template
    content = ""
    xml_path = File.join xml_template_path, @command.xml
    if File.exists?(xml_path)
      # read file in block will close the file handle internally when block terminates
      content = File.open(xml_path, 'r') { |file| file.read }
    else
      Puppet::Error "Cannot read request xml template at location: " + xml_path
    end
    return content
  end
end

formatter = xml_formatter.new("aaaLogin")
