require 'pathname'
require 'rexml/document'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    if (resource[:server_chassis_id].to_s.strip.length != 0 && resource[:server_slot].to_s.strip.length != 0)
      # create profile from server
      create_profile_from_server
    elsif (resource[:source_template] && resource[:source_template].to_s.strip.length > 0)
      # create profile from template
      create_profile_from_template
    end
  end

  def create_profile_from_server
    # creating pnDN
    service_pnDn = "sys/"+ resource[:server_chassis_id] +"/"+ resource[:server_slot]

    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("createServiceProfileFromServer")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = dn
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:pnDn] = service_pnDn

    requestxml = formatter.command_xml(parameters)

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML for the Create Service Profile from Server operation"
    end
    Puppet.debug "Sending create service profile from server request xml: \n" + requestxml
    responsexml = post requestxml
    disconnect
    #parse response xml to check for errors
    begin
      create_doc = REXML::Document.new(responsexml)
      if create_doc.elements["/error"] &&  create_doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occured while creating a service profile from the server: "+  create_doc.elements["/error"].attributes["errorDescr"]
      else
        Puppet.info("Successfully created service profile:"+ resource[:name]+ " from chasis " + resource[:server_chassis_id] +" and server " + resource[:server_slot])
      end
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following issue occurred while parsing the create profile from the server response" +  msg.to_s
    end
  end

  def create_profile_from_template
    # check if the source template name contains 'ls-'
    template_name = resource[:source_template]
    if ! resource[:source_template].start_with?('ls-')
      template_name = "ls-" + resource[:source_template]
    end
    prof_dn = resource[:org]+"/"+ template_name

    # check if the template exists
    verify_param = PuppetX::Util::Ciscoucs::NestedHash.new
    verify_param['/configResolveClass'][:cookie] = cookie
    verify_param['/configResolveClass/inFilter/eq'][:value] = prof_dn
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("verifyServiceProfileTemplate")
    verify_temp_request_xml = formatter.command_xml(verify_param)

    if verify_temp_request_xml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML to verify the template"
    end
    Puppet.debug "Sending request xml: \n" + verify_temp_request_xml
    verify_temp_response_xml = post verify_temp_request_xml
    if verify_temp_response_xml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the verify template operation."
    end
    Puppet.debug "Response from verify template: \n" + verify_temp_response_xml
    # parse and verify template response

    begin
      doc = REXML::Document.new(verify_temp_response_xml)
      if ! doc.elements["/configResolveClass/outConfigs"].has_elements?
        raise Puppet::Error, "The " + resource[:source_template] + " template does not exist."
      end

      template_dn = doc.elements["/configResolveClass/outConfigs/lsServer"].attributes["dn"]

      if(template_dn != prof_dn)
        raise Puppet::Error, "The " + resource[:source_template] + " template does not exist."
      end
    rescue
      raise Puppet::Error, "Unable to parse the template response XML."
    end
    Puppet.debug "Found matching template"

    # create profile from template
    count = 1
    if resource[:number_of_profiles]
      count = resource[:number_of_profiles]
    end
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/lsInstantiateNTemplate'][:dn] = prof_dn
    parameters['/lsInstantiateNTemplate'][:cookie] = cookie
    parameters['/lsInstantiateNTemplate'][:inTargetOrg] = resource[:org]
    parameters['/lsInstantiateNTemplate'][:inServerNamePrefixOrEmpty] = resource[:name]
    parameters['/lsInstantiateNTemplate'][:inNumberOf] = count
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("createServiceProfile")
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for the Create Profile from Template operation."
    end
    Puppet.debug "Sending create profile from template request xml: \n" + requestxml
    responsexml = post requestxml
    disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response for the Create Profile from Template operation."
    end
    Puppet.debug "Response from create profile from template: \n" + responsexml

    #parser response xml to check for errors
    begin
      create_doc = REXML::Document.new(responsexml)
      if create_doc.elements["/error"] &&  create_doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occured while creatng a profile: "+  create_doc.elements["/error"].attributes["errorDescr"]
      else
        Puppet.info("Successfully created the profile: "+ resource[:name]+ " from template " + resource[:source_template])
      end
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following error occurred while parsing the Create Profile from the Template response" +  msg.to_s
    end
  end

  def destroy
    Puppet.notice("Method not supported")
  end

  def dn
    power_dn = ""
    if (resource[:name] && resource[:name].strip.length > 0) && (resource[:org] && resource[:org].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:name]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      power_dn = resource[:org]+ "/"+ profile_name
    elsif (resource[:dn] && resource[:dn].strip.length > 0)
      power_dn = resource[:dn]
    end
    return power_dn
  end

  def power_dn
    dn + "/power"
  end

  def exists?
    if ! check_profile_exists dn
      return false
    elsif (resource[:power_state])
      return true
    end
  end

  def power_state
    begin
      Puppet.debug "Getting power state of the Service Profile."
      power = current_power_state
      if power == 'up' && resource[:power_state].to_s == 'up'
        Puppet.info ("The power is already in the running state.")
      elsif power == 'down' and resource[:power_state].to_s == 'down'
        Puppet.info ("The power state is already off.")
      end
      return power
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
      raise Puppet::Error, "Unable to create a request XML for the Power-on operation."
    end
    Puppet.debug "Sending power on request: \n" + requestxml

    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the Power-on operation."
    end
    Puppet.debug "Response from power on: \n" + responsexml

  end

  def poweroff(parameters)
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("powerOff")
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for the Power-on operation."
    end
    Puppet.debug "Sending power on request: \n" + requestxml

    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the Power-on operation."
    end
    Puppet.debug "Response from power on: \n" + responsexml
  end

  def current_power_state
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("VerifyElementExists")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveDn'][:cookie] = cookie
    parameters['/configResolveDn'][:dn] = dn

    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for verifying the current power state."
    end
    responsexml = post requestxml
    
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response to verify the current power state."
    end
    begin
      doc = REXML::Document.new(responsexml)
      if doc.elements["/configResolveDn/outConfig"].has_elements? && doc.elements["/configResolveDn/outConfig/lsServer"].has_elements?
        return doc.elements["/configResolveDn/outConfig/lsServer/lsPower"].attributes["state"]
      end
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following error occurred while verifying the current power state." +  msg.to_s
    end
  end
end
