require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_serviceprofile_clone).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    #puts "inside create method"

     if @resource[:sourceserviceprofile].strip.length == 0 && @resource[:sourceorganization].strip.length != 0
		raise ArgumentError, "Invalid input arguments."
	  end
	  
	  if @resource[:sourceserviceprofile].strip.length != 0 && @resource[:sourceorganization].strip.length == 0
		raise ArgumentError, "Invalid input arguments."
	  end
	  
	  if @resource[:sourceserviceprofile].strip.length != 0 && @resource[:sourceorganization].strip.length != 0 && @resource[:targetprofilename].strip.length == 0
		@sourceprofilename = resource[:sourceorganization]+'/ls-'+resource[:sourceserviceprofile];
	  else
		@sourceprofilename = resource[:sourceprofilename]
	  end

	  if @resource[:targetrviceprofile].strip.length == 0 && @resource[:targetorganization].strip.length != 0
		raise ArgumentError, "Invalid input arguments."
	  end
	  
	  if @resource[:targetrviceprofile].strip.length != 0 && @resource[:targetorganization].strip.length == 0
		raise ArgumentError, "Invalid input arguments."
	  end 

	  if @resource[:targetrviceprofile].strip.length != 0 && @resource[:targetorganization].strip.length != 0 && @resource[:targetprofilename].strip.length == 0
		@targetprofilename = resource[:targetorganization]+'/ls-'+resource[:targetrviceprofile];
		else
		@targetprofilename = resource[:targetprofilename]
	  end

	    @str = @targetprofilename
		@targetprofilename = @str.split("/ls-").first
		@clonename = @str.split("ls-").last

		formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("createServiceProfileClone")
		parameters = PuppetX::Util::Ciscoucs::NestedHash.new
		parameters['/lsClone'][:dn] = @sourceprofilename
		parameters['/lsClone'][:inTargetOrg] = @targetprofilename
		parameters['/lsClone'][:inServerName] = @clonename
		parameters['/lsClone'][:cookie] = cookie
		parameters['/lsClone'][:inHierarchical] = 'false'
		cloneserverprofilexml = formatter.command_xml(parameters)
		ucscloneserverresp = post cloneserverprofilexml

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

