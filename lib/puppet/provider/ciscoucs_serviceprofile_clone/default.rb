require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_serviceprofile_clone).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    #puts "inside create method"
    @sourceserviceprofile = resource[:sourceserviceprofile]
	@clonename = resource[:clonename]
	@targetorganizationname = resource[:targetorganizationname]
	formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("createServiceProfileClone")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/lsClone'][:dn] = @sourceserviceprofile
    parameters['/lsClone'][:inTargetOrg] = @targetorganizationname
	parameters['/lsClone'][:inServerName] = @clonename
	parameters['/lsClone'][:cookie] = cookie
	parameters['/lsClone'][:inHierarchical] = 'false'
    cloneserverprofilexml = formatter.command_xml(parameters)
    ucscloneserverresp = post cloneserverprofilexml
	#puts "ucscloneserverresp..." + ucscloneserverresp

    cloneresponse = REXML::Document.new(ucscloneserverresp)
    root = cloneresponse.root

   cloneresponse.elements.each("lsClone/outConfig/lsServer") {
		|e|	
		if e.attributes["status"].eql?('created')
			Puppet.notice "Clone service profile created successfully."
		end
	}

    if !root.attributes['errorDescr'].nil?
        raise Puppet::Error, root.attributes['errorDescr']
    end

  end

  def destroy
  #puts "inside destroy method"
  end

  def exists?
	#puts "inside exist method"
  end

end
