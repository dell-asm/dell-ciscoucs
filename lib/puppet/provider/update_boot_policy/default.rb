require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:update_boot_policy).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    #puts "inside create method"

		formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("updateBootPolicy")
		parameters = PuppetX::Util::Ciscoucs::NestedHash.new
		parameters['/configConfMos/inConfigs/pair/lsServer'][:bootPolicyName] = resource[:bootpolicyname]
		parameters['/configConfMos/inConfigs/pair'][:key] = resource[:key]
		parameters['/configConfMos/inConfigs/pair/lsServer'][:status] = 'created,modified'
		parameters['/configConfMos'][:cookie] = cookie
		parameters['/configConfMos'][:inHierarchical] = 'true'
		updatebootpolicyxml = formatter.command_xml(parameters)
		updatebootpolicyresp = post updatebootpolicyxml
		response = REXML::Document.new(updatebootpolicyresp)
		#puts "updatebootpolicyresp..." +updatebootpolicyresp
		root = response.root

		if !root.attributes['errorDescr'].nil?
			raise Puppet::Error, root.attributes['errorDescr']
		else
			Puppet.info("boot policy successfully updated to "+ resource[:key])
	    end

	  end

  def destroy
  #puts "inside destroy method"
  end

  def service_profile_dn
    profile_dn= resource[:key]
    return profile_dn
  end

  def exists?
    # check if the source profile exists
    if check_profile_exists service_profile_dn
      # source profile exists, execute update service profile operation
      return false
    end
    # error
    raise Puppet::Error, "No such profile exists " + service_profile_dn
  end

end

