require 'pathname'

mod = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s).path rescue Pathname.new(__FILE__).parent.parent.parent.parent.parent
require File.join mod, 'lib/puppet/type/transport_ciscoucs'
require File.join mod, 'lib/puppet_x/puppetlabs/transport'
require File.join mod, 'lib/puppet_x/puppetlabs/transport/ciscoucs'
require File.join mod, 'lib/puppet/provider/ciscoucs'

Puppet::Type.type(:ciscoucs_serviceprofile_clone).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
  puts "inside create method"
    dn = resource[:source]
	inServerName = resource[:clonename]
	inTargetOrg = resource[:target]
	cloneServerProfileXML = '<lsClone dn="org-root/ls-'+dn+'" cookie="' + cookie + '" inTargetOrg="org-root/org-'+inTargetOrg+'" inServerName="'+inServerName+'" inHierarchical="false"></lsClone>'
    ucsCloneServerResp = post cloneServerProfileXML
	puts "ucsCloneServerResp..." + ucsCloneServerResp

  end

  def destroy
  puts "inside destroy method"
  end

  def exists?
	puts "inside exist method"
    #@property_hash[:ensure] == :present
	  def exists?
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="org-root/ls-'+resource[:inServerName]+'" />'
    response_xml = post request_xml
    doc = REXML::Document.new(response_xml)
    root = doc.root
    value  = doc.elements["/configResolveDn/outConfig"].has_elements?
  end
  end

end
