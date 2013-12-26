require 'rest-client'
require 'pathname'
mod = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s).path rescue Pathname.new(__FILE__).parent.parent.parent.parent.parent
require File.join mod, 'lib/puppet/type/transport'
require File.join mod, 'lib/puppet_x/puppetlabs/transport'
require File.join mod, 'lib/puppet_x/puppetlabs/transport/ciscoucs'
require File.join mod, 'lib/puppet/provider/ciscoucs'

#require 'pathname'
#provider_path = Pathname.new(__FILE__).parent.parent
#require File.join(provider_path, 'ciscoucs')
 Puppet.debug "************* Step -1***********"

Puppet::Type.type(:create_service_profile).provide(:default) do
 Puppet.debug "************* Step -2***********"
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
 Puppet.debug "************* Step -3***********"
  @doc = "Create server profile on Cisco UCS device."

  def create
   @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')
    @transport.cookie
    @transport.url
    name = resource[:name]
	agentPolicyName = resource[:agentpolicyname]
	biosProfileName = resource[:biosprofilename]
	bootPolicyName = resource[:bootpolicyname]
	descr = resource[:descr]
	dn = resource[:dn]
	dynamicConPolicyName = resource[:dynamicconpolicyname]
	extIPPoolName = resource[:extippoolname]
	extIPState = resource[:extipstate]
	hostFwPolicyName = resource[:hostfwpolicyname]
	identPoolName = resource[:identpoolname]
	localDiskPolicyName = resource[:localdiskpolicyname]
	maintPolicyName = resource[:maintpolicyname]
	mgmtAccessPolicyName = resource[:mgmtaccesspolicyname]
	mgmtFwPolicyName = resource[:mgmtfwpolicyname]
	policyOwner = resource[:policyowner]
	powerPolicyName = resource[:powerpolicyname]
	scrubPolicyName = resource[:scrubpolicyname]
	solPolicyName = resource[:solpolicyname]
	srcTemplName = resource[:srctemplname]
	statsPolicyName = resource[:statspolicyname]
	usrLbl = resource[:usrlbl]
	uuid = resource[:uuid]
	status = resource[:status]
	vconProfileName = resource[:vconprofilename]
	createServerProfilefromTemplateXML = '<configConfMos cookie="' + @transport.cookie + '" inHierarchical="false"><inConfigs> <pair key="org-root/ls'+name+'"><lsServer agentPolicyName="'+agentPolicyName+'" biosProfileName="'+biosProfileName+'" bootPolicyName="'+bootPolicyName+'"  descr="'+descr+'" dn="'+dn+'" dynamicConPolicyName="'+dynamicConPolicyName+'" extIPPoolName="'+extIPPoolName+'" extIPState="'+extIPState+'" hostFwPolicyName="'+hostFwPolicyName+'" identPoolName="'+identPoolName+'" localDiskPolicyName="'+localDiskPolicyName+'" maintPolicyName="'+maintPolicyName+'" mgmtAccessPolicyName="'+mgmtAccessPolicyName+'" mgmtFwPolicyName="'+mgmtFwPolicyName+'" name="'+name+'" policyOwner="'+policyOwner+'" powerPolicyName="'+powerPolicyName+'" scrubPolicyName="'+scrubPolicyName+'" solPolicyName="'+solPolicyName+'" srcTemplName="'+srcTemplName+'" statsPolicyName="'+statsPolicyName+'" status="'+status+'"  usrLbl="'+usrLbl+'" uuid="'+uuid+'" vconProfileName="'+vconProfileName+'"></lsServer></pair></inConfigs> </configConfMos>'
    ucsCreaeTemplateResp = RestClient.post @transport.url, createServerProfilefromTemplateXML, :content_type => 'text/xml'
    Puppet.debug ucsCreaeTemplateResp
    Puppet.debug "ucsCreaeTemplateResp " + ucsCreaeTemplateResp
    

  end
 
def destroy

 end


  def exists?
   @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')
    @transport.cookie
    @transport.url
    name = resource[:name]
	agentPolicyName = resource[:agentpolicyname]
	biosProfileName = resource[:biosprofilename]
	bootPolicyName = resource[:bootpolicyname]
	descr = resource[:descr]
	dn = resource[:dn]
	dynamicConPolicyName = resource[:dynamicconpolicyname]
	extIPPoolName = resource[:extippoolname]
	extIPState = resource[:extipstate]
	hostFwPolicyName = resource[:hostfwpolicyname]
	identPoolName = resource[:identpoolname]
	localDiskPolicyName = resource[:localdiskpolicyname]
	maintPolicyName = resource[:maintpolicyname]
	mgmtAccessPolicyName = resource[:mgmtaccesspolicyname]
	mgmtFwPolicyName = resource[:mgmtfwpolicyname]
	policyOwner = resource[:policyowner]
	powerPolicyName = resource[:powerpolicyname]
	scrubPolicyName = resource[:scrubpolicyname]
	solPolicyName = resource[:solpolicyname]
	srcTemplName = resource[:srctemplname]
	statsPolicyName = resource[:statspolicyname]
	usrLbl = resource[:usrlbl]
	uuid = resource[:uuid]
	status = resource[:status]
	vconProfileName = resource[:vconprofilename]
	createServerProfilefromTemplateXML = '<configConfMos cookie="' + @transport.cookie + '" inHierarchical="false"><inConfigs> <pair key="org-root/ls'+name+'"><lsServer agentPolicyName="'+agentPolicyName+'" biosProfileName="'+biosProfileName+'" bootPolicyName="'+bootPolicyName+'"  descr="'+descr+'" dn="'+dn+'" dynamicConPolicyName="'+dynamicConPolicyName+'" extIPPoolName="'+extIPPoolName+'" extIPState="'+extIPState+'" hostFwPolicyName="'+hostFwPolicyName+'" identPoolName="'+identPoolName+'" localDiskPolicyName="'+localDiskPolicyName+'" maintPolicyName="'+maintPolicyName+'" mgmtAccessPolicyName="'+mgmtAccessPolicyName+'" mgmtFwPolicyName="'+mgmtFwPolicyName+'" name="'+name+'" policyOwner="'+policyOwner+'" powerPolicyName="'+powerPolicyName+'" scrubPolicyName="'+scrubPolicyName+'" solPolicyName="'+solPolicyName+'" srcTemplName="'+srcTemplName+'" statsPolicyName="'+statsPolicyName+'" status="'+status+'"  usrLbl="'+usrLbl+'" uuid="'+uuid+'" vconProfileName="'+vconProfileName+'"></lsServer></pair></inConfigs> </configConfMos>'
    ucsCreaeTemplateResp = RestClient.post @transport.url, createServerProfilefromTemplateXML, :content_type => 'text/xml'
    Puppet.debug ucsCreaeTemplateResp
    Puppet.debug "ucsCreaeTemplateResp " + ucsCreaeTemplateResp
   #a = resource[:name] ? false : true
    return true
  end

end
