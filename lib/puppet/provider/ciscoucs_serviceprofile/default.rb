require 'rest-client'
require 'pathname'

mod = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s).path rescue Pathname.new(__FILE__).parent.parent.parent.parent.parent
require File.join mod, 'lib/puppet/type/transport'
require File.join mod, 'lib/puppet_x/puppetlabs/transport'
require File.join mod, 'lib/puppet_x/puppetlabs/transport/ciscoucs'
require File.join mod, 'lib/puppet/provider/ciscoucs'

Puppet::Type.type(:ciscoucs_serverprofile).provide(:default) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')
    @transport.cookie
    @transport.url
    name = resource[:name]
    serverProfilePowerOnXML = '<configConfMo dn="org-root/ls-'+name+'/power" cookie="' + @transport.cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-up"> </lsPower> </inConfig> </configConfMo>'

    ucsPowerResp = RestClient.post @transport.url, serverProfilePowerOnXML, :content_type => 'text/xml'

  end

  def destroy
    @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')

    @transport.cookie
    @transport.url
    name = resource[:name]
    serverProfilePowerOffXML = '<configConfMo dn="org-root/ls-'+name+'/power" cookie="' + @transport.cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-down"> </lsPower> </inConfig> </configConfMo>'

    ucsPowerResp = RestClient.post @transport.url, serverProfilePowerOffXML, :content_type => 'text/xml'

  end

  def exists?
    #a = resource[:name] ? false : true
    false
    #Puppet.debug "------- output ------" + a.to_s
  end

end
