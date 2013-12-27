require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_association).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transport
  @doc = "Associate server profile on Cisco UCS device."
  def create

    name=resource[:name]

    profile_dn = resource[:profile_dn]
    if profile_dn == ""
      profile_dn = 'org-'+resource[:organization_name]+'/ls-'+resource[:service_profile_name];
    end

    server_dn = resource[:server_dn]
    if server_dn == ""
      server_dn = 'sys/'+resource[:server_chesis_id]+'/'+resource[:server_slot];
    end

    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("associateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:pnDn] = server_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:descr] = "Service Profile Associated by ASM";
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:rn] = "pn";
    requestxml = formatter.command_xml(parameters);

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for asoociate operation"
    end
    responsexml = RestClient.post url, requestxml, :content_type => 'text/xml'
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from Associate operation"
    end

    puts 'Please wait... Server Profile is getting associated';
    
  end

  def destroy

    name=resource[:name]
    profile_dn = resource[:profile_dn]
    if profile_dn == ""
      profile_dn = 'org-'+resource[:organization_name]+'/ls-'+resource[:service_profile_name];
    end

    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("disAssociateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:status] = "deleted";
    parameters['/configConfMos/inConfigs/pair/lsServer'][:descr] = "Service Profile Dis Associated by ASM";
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:rn] = "pn";
    requestxml = formatter.command_xml(parameters);

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for Dis-Associate operation"
    end
    responsexml = RestClient.post url, requestxml, :content_type => 'text/xml'
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from Dis-associate operation"
    end

    puts 'Please wait... Server Profile is getting dis-associated';

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

end