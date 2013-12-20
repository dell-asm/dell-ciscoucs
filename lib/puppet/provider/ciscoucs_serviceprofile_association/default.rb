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
      
    organizationname = resource[:organizationname]
    serviceprofilename = resource[:serviceprofilename]
    dnorganizationname = resource[:dnorganizationname]
    dnserviceprofilename = resource[:dnserviceprofilename]
    serverchesisid = resource[:serverchesisid]
    serverslot = resource[:serverslot]
            
    @profile_associate_input_xml =
    '<configConfMos
          cookie="'+cookie+'"
          inHierarchical="false">
              <inConfigs>
          <pair key="org-'+organizationname+'/ls-'+serviceprofilename+'">
              <lsServer
              agentPolicyName=""
              biosProfileName=""
              bootPolicyName=""
              descr=""
              dn="org-'+dnorganizationname+'/ls-'+dnserviceprofilename+'"
              dynamicConPolicyName=""
              extIPPoolName="ext-mgmt"
              extIPState="none"
              hostFwPolicyName=""
              identPoolName=""
              localDiskPolicyName=""
              maintPolicyName=""
              mgmtAccessPolicyName=""
              mgmtFwPolicyName=""
              policyOwner="local"
              powerPolicyName="default"

              scrubPolicyName=""
              solPolicyName=""
              srcTemplName=""
              statsPolicyName="default"
              status="modified"
              usrLbl=""
              uuid="0"
              vconProfileName="">
                  <lsBinding
                  pnDn="sys/'+serverchesisid+'/'+serverslot+'"
                  restrictMigration="no"
                  rn="pn"
                  >
                  </lsBinding>
              </lsServer>
          </pair>
              </inConfigs>
          </configConfMos>';
    puts @profile_associate_input_xml;
    @profile_associate_output_xml = RestClient.post url, @profile_associate_input_xml, :content_type => 'text/xml';
    puts "Server profile associate- " + @profile_associate_output_xml;
    
  end
  
    def destroy
      end
     
      
  def exists?
      #a = resource[:name] ? false : true
      false
      #Puppet.debug "------- output ------" + a.to_s
    end
    
end