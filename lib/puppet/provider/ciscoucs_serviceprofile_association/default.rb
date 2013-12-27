require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_association).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transport
  @doc = "Associate server profile on Cisco UCS device."
  def create
    
    #@serverchesisid = resource[:serverchesisid]
    @pndn = resource[:pndn]
    #@serverslot = resource[:serverslot]      
    @serviceprofilename = resource[:serviceprofilename]   

      
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("associateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new

    puts "---------befor xml"
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos'][:inHierarchical] = 'false'
    parameters['/configConfMos/inConfigs/pair'][:key] = @serviceprofilename
    parameters['/configConfMos/inConfigs/pair/lsBinding'][:dn] = @serviceprofilename
    parameters['/configConfMos/inConfigs/pair/lsBinding'][:pnDn] = @pndn
    parameters['/configConfMos/inConfigs/pair/lsBinding'][:restrictMigration] = 'no'
      
    profile_associate_input_xml = formatter.command_xml(parameters)
      
    profile_associate_output_xml = post profile_associate_input_xml;
    
    assoresponse = REXML::Document.new(profile_associate_output_xml)
    root = assoresponse.root
    puts assoresponse
      


  end

  def destroy

    
  end

  #check If exist
  def exists?

  end

end