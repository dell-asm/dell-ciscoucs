require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/Xmlformatter'

Puppet::Type.type(:ciscoucs_serviceprofile_bootpolicy).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Modify service profile boot policy on cisco ucs device."
  def create

	# Check if the user is trying to apply the boot policy which is not applicable to that particular service profile
	serviceprofile_organization = service_profile_dn.split("/ls-").first
	serviceprofile_name = service_profile_dn.split("/ls-").last
	bootpolicy_organization = boot_policy_dn.split("/boot-policy-").first
	bootpolicy_name = boot_policy_dn.split("/boot-policy-").last
	if serviceprofile_organization.to_s.strip.length < bootpolicy_organization.to_s.strip.length
      raise Puppet::Error, "The boot policy " +bootpolicy_name+ " can't be applied to the service profile: " +serviceprofile_name
    end
    # check if the boot policy exists
    if ! check_boot_policy_exists boot_policy_dn
      raise Puppet::Error, "The " + boot_policy_dn + " boot policy does not exist." 
    end

    str = boot_policy_dn
    bootpolicyname = str.split("boot-policy-").last
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("modifyBootPolicy")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos/inConfigs/pair/lsServer'][:bootPolicyName] = bootpolicyname
    parameters['/configConfMos/inConfigs/pair'][:key] = service_profile_dn
    parameters['/configConfMos'][:cookie] = cookie
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML for the Modify Boot Policy operation."
    end
    responsexml = post requestxml
    disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get response from the Modify Boot Policy operation."
    end

    #parser response xml to check for errors
    begin
      doc = REXML::Document.new(responsexml)
      if doc.elements["/error"] &&  doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occured while modifying the boot policy on the service profile: "+  doc.elements["/error"].attributes["errorDescr"]
      elsif doc.elements["/configConfMos"] &&  doc.elements["/configConfMos"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occurred while modifying the boot policy on the service profile: "+  doc.elements["/configConfMos"].attributes["errorDescr"]
      else
        Puppet.notice("Successfully modified the boot policy: "+ bootpolicyname)
      end
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following issue occurred while parsing the Modify Boot Policy operation response." +  msg.to_s
    end
  end

  def destroy
    Puppet.notice("Method not supported")
  end

  def boot_policy_dn
    policy_dn = ""
    if (resource[:bootpolicy_name] && resource[:bootpolicy_name].strip.length > 0) &&
    (resource[:bootpolicy_organization] && resource[:bootpolicy_organization].strip.length > 0)
      policy_name = resource[:bootpolicy_name]
      if ! policy_name.start_with?('boot-policy-')
        policy_name= "boot-policy-" + policy_name
      end
      policy_dn = resource[:bootpolicy_organization] +"/"+ policy_name
    elsif (resource[:bootpolicy_dn] && resource[:bootpolicy_dn].strip.length > 0)
      policy_dn = resource[:bootpolicy_dn]
    end
    return policy_dn
  end

  def service_profile_dn
    profile_dn = ""
    if (resource[:serviceprofile_name] && resource[:serviceprofile_name].strip.length > 0) &&
    (resource[:serviceprofile_organization]  && resource[:serviceprofile_organization].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:serviceprofile_name]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      profile_dn = resource[:serviceprofile_organization] +"/"+ profile_name
    elsif (resource[:serviceprofile_dn] && resource[:serviceprofile_dn].strip.length > 0)
      profile_dn = resource[:serviceprofile_dn]
    end
    return profile_dn
  end

  def exists?
    # check if the source profile exists
    if check_profile_exists service_profile_dn
      # source profile exists, execute modify service profile operation
      # check the ensure input value
      if (resource[:ensure].to_s =="modify")
        return false;
      end
      return true;
    end
    # error
    raise Puppet::Error, "The " + service_profile_dn + " service profile does not exist."
  end

end

