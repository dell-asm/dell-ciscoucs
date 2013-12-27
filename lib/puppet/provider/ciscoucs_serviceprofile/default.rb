require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    if resource[:source_template].to_s.strip.length == 0
      # create profile from server
      create_profile_from_server
    else
      # create profile from template
      create_profile_from_template
    end
      
    name = resource[:profile_name]
    if resource [:template_name]
      # create profile from template
    else
      # create a profile
    end
    server_profile_power_on_xml = '<configConfMo dn="org-root/ls-'+name+'/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-up"> </lsPower> </inConfig> </configConfMo>'
    response_xml = post request_xml
  end

  def create_profile_from_server
    
  end
  
  def create_profile_from_template
    
  end

  def destroy
    # todo: delete profile
  end

  def dn
    power_dn = ""
    if resource[:name] && resource[:org]
      power_dn = resource[:org]+"/ls-" + resource[:name]
    elsif resource[:dn]
      power_dn = resource[:dn]
    end
    return power_dn
  end

  def power_dn
    dn + "/power"
  end

  def exists?
    check_profile_exists dn
  end

  def power_state
    Puppet.debug "Getting power state of the Service Profile."
    begin
      # TODO: not sure what needs to be done here
    rescue Exception => exception
      puts exception.message
    end
  end

  def power_state=(value)
    Puppet.debug "Setting the power state of service profile."
    begin
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/configConfMo'][:dn] = power_dn
      parameters['/configConfMo'][:cookie] = cookie
      parameters['/configConfMo/inConfig/lsPower'][:dn] = power_dn

      # power off the service profile
      if value == :down
        Puppet.debug "Power down the service profile"
        poweroff parameters
        # power on the service profile
      elsif value == :up
        Puppet.debug "Power up the service profile"
        poweron parameters
      end

      disconnect

    rescue Exception => exception
      puts "Unable to perform the operation because the following exception occurred."
      puts exception.message
    end
  end

  def poweron(parameters)
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("powerOn")
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for power-on operation"
    end
    Puppet.debug "Sending power on request: \n" + requestxml

    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from power-on operation"
    end
    Puppet.debug "Response from power on: \n" + responsexml

  end

  def poweroff(parameters)
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("powerOff")
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for power-on operation"
    end
    Puppet.debug "Sending power on request: \n" + requestxml

    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from power-on operation"
    end
    Puppet.debug "Response from power on: \n" + responsexml
  end

end
