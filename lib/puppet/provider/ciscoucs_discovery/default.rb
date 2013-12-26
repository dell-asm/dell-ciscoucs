require 'pathname'
require 'rexml/document'

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_discovery).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh
  include PuppetX::Puppetlabs::Transport
  @doc = "Discover Blade Servers on cisco ucs."
  def create   
    name=resource[:name]
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("discover")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:classId] = 'computeBlade'
    parameters['/configResolveClass'][:cookie] = cookie
    
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
            raise Puppet::Error, "Cannot create request xml for discover operation"
    end    
    response_xml = post requestxml
        
    ucsBladesDoc = REXML::Document.new(response_xml)
    ucsBladesDoc.elements.each("configResolveClass/outConfigs/*") {
      |blade|
      bladeName = blade.attributes["dn"]
      bladeSerialNum = blade.attributes["serial"]
      bladeSlotId = blade.attributes["slotId"]
      bladeChassisId = blade.attributes["chassisId"]      
      
      puts "BladeDN " + bladeName
      puts "BladebSerialNum " + bladeSerialNum
      puts "BladeSlotId " + bladeSlotId
      puts "BladeChassisId " + bladeChassisId
      
    }
        
  end
  def destroy
     # Empty
  end
  def exists?    
      ens = resource[:ensure]
      result = false;
      if (ens.to_s =="absent")       
        result = true;
      elsif (ens.to_s =="absent")        
        result = true;
      end  
     
      return result;
  end

end
