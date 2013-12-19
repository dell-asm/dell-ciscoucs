require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_associate).provide(:default, :parent => Puppet::Provider::CiscoUCS) do
  @doc = "Manage association of service profile on Cisco UCS device."

  def create
    self.transport
    @transport
    name=resource[:name]
      
    @profile_associate_input_xml =
    '<configConfMos
          cookie="'+cookie+'"
          inHierarchical="false">
              <inConfigs>
          <pair key="org-'+organization_name+'/ls-'+service_profile_name+'">
              <lsServer
              agentPolicyName=""
              biosProfileName=""
              bootPolicyName=""
              descr=""
              dn="org-'+dn_organization_name+'/ls-'+dn_service_profile_name+'"
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
                  pnDn="sys/'+server_chesis_id+'/'+server_slot+'"
                  restrictMigration="no"
                  rn="pn"
                  >
                  </lsBinding>
              </lsServer>
          </pair>
              </inConfigs>
          </configConfMos>';
    puts @profile_associate_input_xml;
    @profile_associate_output_xml = RestClient.post @url, @profile_associate_input_xml, :content_type => 'text/xml';
    puts "Server profile associate- " + @profile_associate_output_xml;
    
  end
  
    def destroy
        self.transport
        @transport
        
      request_xml = '<configConfMos cookie="' + @transport + '" inHierarchical ="false">
          <inConfigs>
      <pair key="org-root/ls-test/pn-req">
          <lsRequirement          
          dn="org-root/ls-test/pn-req"          
          status="deleted">
          </lsRequirement>
      </pair>
          </inConfigs>
      </configConfMos>'

        puts request_xml
        
      response_xml = RestClient.post url, request_xml, :content_type => 'text/xml'
              
        puts "Server profile disassociate- " + response_xml
      end
end