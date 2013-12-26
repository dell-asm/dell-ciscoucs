require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_association).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transport
  @doc = "Associate server profile on Cisco UCS device."
  def create
    name=resource[:name]
    serverchesisid = resource[:serverchesisid]
    serverslot = resource[:serverslot]      
    profile_dn = resource[:profile_dn]    
    server_dn = resource[:server_dn]

    @profile_associate_input_xml =
    '<configConfMos cookie="'+cookie+'" inHierarchical="false">
        <inConfigs>
            <pair key="'+profile_dn+'">
                <lsServer dn="'+profile_dn+'">
                    <lsBinding pnDn="'+server_dn+'" rn="pn">
                    </lsBinding>
                </lsServer>
            </pair>
        </inConfigs>
    </configConfMos>';

    @profile_associate_output_xml = RestClient.post url, @profile_associate_input_xml, :content_type => 'text/xml';
    
    puts @profile_associate_output_xml;

  end

  def destroy

    name=resource[:name]      
    profile_dn = resource[:profile_dn]

    @profile_disassociate_input_xml =
    '<configConfMos cookie="'+cookie+'" inHierarchical="false">
         <inConfigs>
            <pair key="'+profile_dn+'">
                <lsBinding dn="'+profile_dn+'" status="deleted" >
                 </lsBinding>
            </pair>
          </inConfigs>
        </configConfMos>';

    @profile_disassociate_output_xml = RestClient.post url, @profile_disassociate_input_xml, :content_type => 'text/xml';

    puts @profile_disassociate_output_xml;
  end

  #check If exist
  def exists?
    ens = resource[:ensure]
    result = false;
    if (ens.to_s =="present")
      result = false;
    elsif (ens.to_s =="absent")
      result = true;
    end
    return result;
  end

end