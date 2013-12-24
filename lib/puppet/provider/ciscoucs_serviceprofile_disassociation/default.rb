require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_disassociation).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage dis-association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transport
  @doc = "Associate server profile on Cisco UCS device."
  def create
    name=resource[:name]
    organizationname = resource[:organizationname]
    serviceprofilename = resource[:serviceprofilename]
    dnorganizationname = resource[:dnorganizationname]
    dnserviceprofilename = resource[:dnserviceprofilename]
    serverchesisid = resource[:serverchesisid]
    serverslot = resource[:serverslot]

    @profile_associate_input_xml =
    '<configConfMos cookie="'+cookie+'" inHierarchical="false">
      <inConfigs>
         <pair key="org-'+organizationname+'/ls-'+serviceprofilename+'">
             <lsBinding dn="org-'+organizationname+'/ls-'+serviceprofilename+'" status="deleted" >
              </lsBinding>
         </pair>
       </inConfigs>
     </configConfMos>';
     
    @profile_associate_output_xml = RestClient.post url, @profile_associate_input_xml, :content_type => 'text/xml';
    
  end

  #Method for destroy
  def destroy
  end

  #check If exist
  def exists?
    return false;
  end

end