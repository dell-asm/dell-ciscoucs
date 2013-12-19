require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serverprofile_associate).provide(:default, :parent => Puppet::Provider::CiscoUCS) do
  @doc = "Manage association of server profile on Cisco UCS device."

  def create
      self.transport
      @transport
    name=resource[:name]

    request_xml = '<configConfMos cookie="' + @transport + '"inHierarchical="false">
        <inConfigs>
    <pair key="org-root/ls-test">
        <lsServer
        agentPolicyName=""
        biosProfileName=""
        bootPolicyName=""
        
        descr=""
        dn="org-root/ls-test"
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
        status="created,modified"
        usrLbl=""
        uuid="0"
        vconProfileName="">
            <lsRequirement
            
            
            name="' + name + '" qualifier=""
            restrictMigration="no"
            rn="pn-req"
            >
            </lsRequirement>
            <lsPower
            rn="power"
            state="admin-up"
            >
            </lsPower>
        </lsServer>
    </pair>
        </inConfigs>
    </configConfMos>'


      puts request_xml      
      response_xml = RestClient.post url, request_xml, :content_type => 'text/xml'      
      
      puts "Server profile associate- " + response_xml
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