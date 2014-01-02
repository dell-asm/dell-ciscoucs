require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_modify_serviceprofile_boot_policy).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    # check if the boot policy exists
    if ! check_boot_policy_exists boot_policy_dn
      raise Puppet::Error, "No such boot policy exits " + boot_policy_dn
    end

    str = boot_policy_dn
    bootpolicyname = str.split("boot-policy-").last
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("modifyBootPolicy")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos/inConfigs/pair/lsServer'][:bootPolicyName] = bootpolicyname
    parameters['/configConfMos/inConfigs/pair'][:key] = service_profile_dn
    parameters['/configConfMos'][:cookie] = cookie
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for modify boot policy operation"
    end
    responsexml = post requestxml
    disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from modify boot policy operation"
    end

    #parser response xml to check for errors
    begin
      doc = REXML::Document.new(responsexml)
      if doc.elements["/error"] &&  doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Following error occurred while modifying boot policy on service profile : "+  doc.elements["/error"].attributes["errorDescr"]
      elsif doc.elements["/configConfMos"] &&  doc.elements["/configConfMos"].attributes["errorCode"]
        raise Puppet::Error, "Following error occurred while modifying boot policy on service profile : "+  doc.elements["/configConfMos"].attributes["errorDescr"]
      else
        Puppet.info("boot policy modified Successfully  "+ bootpolicyname)
      end
    rescue Exception => msg
      raise Puppet::Error, "Following error occurred while parsing modify boot policy response" +  msg.to_s
    end
  end

  def destroy
    Puppet.notice("Method not supported")
  end

  def boot_policy_dn
    policy_dn = ""
    if (resource[:bootpolicyname] && resource[:bootpolicyname].strip.length > 0) &&
    (resource[:bootpolicyorganization] && resource[:bootpolicyorganization].strip.length > 0)
      policy_name = resource[:bootpolicyname]
      if ! policy_name.start_with?('boot-policy-')
        policy_name= "boot-policy-" + policy_name
      end
      policy_dn = resource[:bootpolicyorganization] +"/"+ policy_name
    elsif (resource[:bootpolicydn] && resource[:bootpolicydn].strip.length > 0)
      policy_dn = resource[:bootpolicydn]
    end
    return policy_dn
  end

  def service_profile_dn
    profile_dn = ""
    if (resource[:serviceprofilename] && resource[:serviceprofilename].strip.length > 0) &&
    (resource[:serviceprofileorganization]  && resource[:serviceprofileorganization].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:serviceprofilename]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      profile_dn = resource[:serviceprofileorganization] +"/"+ profile_name
    elsif (resource[:serviceprofiledn] && resource[:serviceprofiledn].strip.length > 0)
      profile_dn = resource[:serviceprofiledn]
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
    raise Puppet::Error, "No such profile exists  " + service_profile_dn
  end

end

