require 'pathname'
require 'rexml/document'

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
    sourceserviceprofile = resource[:sourceserviceprofile]
	clonename = resource[:clonename]
	targetorganizationname = resource[:targetorganizationname]
	cloneserverprofilexml = '<lsClone dn="'+sourceserviceprofile+'" cookie="' + cookie + '" inTargetOrg="'+targetorganizationname+'" inServerName="'+clonename+'" inHierarchical="false"></lsClone>'
    ucscloneserverresp = post cloneserverprofilexml
	#puts "ucscloneserverresp..." + ucscloneserverresp

    cloneresponse = REXML::Document.new(ucscloneserverresp)
    root = cloneresponse.root
    #errorCode = root.attributes['errorCode']
	#puts "errorCode..." + errorCode

	if root.attributes['status'].eql?("created")
        Puppet.notice "Clone service profile successfully created."
	end

    if root.attributes['status'].nil?
	if root.attributes['errorCode'].eql?("103")
        Puppet.notice "Cannot create clone, service profile already exists."
	end
	if root.attributes['errorCode'].eql?("102")
        Puppet.notice "Cannot create clone, as the source service profile does not exist."
    end
  end

  end

  def destroy
  #puts "inside destroy method"
  end

  def exists?
	#puts "inside exist method"
  end

end
