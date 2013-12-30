require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_association).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transport
  @doc = "Associate or disassociate server profile on Cisco UCS device."

  def create
    # check if the profile exists
    if ! check_profile_exists profile_dn
      raise Puppet::Error, "No such profile exists " + profile_dn
    end

    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("associateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:pnDn] = server_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:descr] = "Service Profile Association";
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:rn] = "pn";
    requestxml = formatter.command_xml(parameters);

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for associate profile operation"
    end
    Puppet.debug "Sending associate profile request xml: \n" + requestxml
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from associate profile operation"
    end
    Puppet.debug "Response from associate profile: \n" + responsexml
    # todo: error handling
  end

  def destroy
    # check if the profile exists
    if ! check_profile_exists profile_dn
      raise Puppet::Error, "No such profile exists " + profile_dn
    end
    
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("disAssociateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:status] = "deleted";
    parameters['/configConfMos/inConfigs/pair/lsServer'][:descr] = "Service Profile Disassociation";
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:rn] = "pn";
    requestxml = formatter.command_xml(parameters);

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for associate profile operation"
    end
    Puppet.debug "Sending associate profile request xml: \n" + requestxml
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from associate profile operation"
    end
    Puppet.debug "Response from associate profile: \n" + responsexml
    # todo: error handling

  end

  def server_dn
    source_dn = ""
    if (resource[:server_chassis_id] && resource[:server_chassis_id].strip.length > 0) &&
    (resource[:server_slot]  && resource[:server_slot].strip.length > 0)
      source_dn = 'sys/'+resource[:server_chassis_id]+'/'+resource[:server_slot];
    elsif (resource[:profile_dn] && resource[:profile_dn].strip.length > 0)
      source_dn = resource[:profile_dn]
    end
    return source_dn
  end

  def profile_dn
    source_dn = ""
    if (resource[:organization_name] && resource[:organization_name].strip.length > 0) &&
    (resource[:service_profile_name]  && resource[:service_profile_name].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:service_profile_name]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      source_dn = resource[:organization_name] +"/"+ profile_name
    elsif (resource[:server_dn] && resource[:server_dn].strip.length > 0)
      source_dn = resource[:server_dn]
    end
    return source_dn
  end

  #check If exist
  def exists?
    ens = resource[:ensure]
    result = true;
    if (ens.to_s =="present")
      result = false;
    end
    return result;
  end
  #question: do we have to delete the profile
end