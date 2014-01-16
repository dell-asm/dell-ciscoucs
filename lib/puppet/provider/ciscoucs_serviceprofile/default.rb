require 'pathname'
require 'rexml/document'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh
  include PuppetX::Puppetlabs::Transportciscoucs
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

    # check if the service profile exists
    service_profile_exist = false
    verify_param = PuppetX::Util::Ciscoucs::NestedHash.new
    verify_param['/configResolveClass'][:cookie] = cookie
    verify_param['/configResolveClass/inFilter/eq'][:value] = dn
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("verifyServiceProfile")
    verify_service_profile_request_xml = formatter.command_xml(verify_param)

    if verify_service_profile_request_xml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML to verify the service profile"
    end

    verify_service_profile_response_xml = post verify_service_profile_request_xml
    if verify_service_profile_response_xml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the verify service profile operation."
    end

    # parse and verify service profile response
    begin
      doc = REXML::Document.new(verify_service_profile_response_xml)
      if doc.elements["/configResolveClass/outConfigs"].has_elements?
        if doc.elements["/configResolveClass/outConfigs/lsServer"].attributes["dn"].to_s.strip.length!= 0
          Puppet.notice("The service profile " + dn + " already exist.")
          service_profile_exist= true
          disconnect
        end
      end
    end

    if !service_profile_exist
      # creating pnDN
      service_pnDn = "sys/"+ resource[:server_chassis_id] +"/"+ resource[:server_slot]

      formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("createServiceProfileFromServer")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/configConfMos'][:cookie] = cookie
      parameters['/configConfMos/inConfigs/pair'][:key] = dn
      parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = dn
      parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:pnDn] = service_pnDn

      requestxml = formatter.command_xml(parameters)
      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Unable to create the request XML for the Create Service Profile from Server operation"
      end

      responsexml = post requestxml
      disconnect
      #parse response xml to check for errors
      begin
        create_doc = REXML::Document.new(responsexml)
        if create_doc.elements["/error"] &&  create_doc.elements["/error"].attributes["errorCode"]
          raise Puppet::Error, "Unable to perform the operation because the following issue occured while creating a service profile from the server: "+  create_doc.elements["/error"].attributes["errorDescr"]
        elsif  create_doc.elements["configConfMos/outConfigs/pair/lsServer"].attributes["operState"].to_s=="config-failure"
          raise Puppet::Error, "Unable to perform the operation because the following issue occured while creating a service profile from the server: "+  create_doc.elements["/configConfMos/outConfigs/pair/lsServer"].attributes["configQualifier"]
        else
          Puppet.notice("Successfully created service profile:"+ dn + " from chasis " + resource[:server_chassis_id] +" and server " + resource[:server_slot])
        end
      rescue Exception => msg
        raise Puppet::Error, "Unable to perform the operation because the following issue occurred while parsing the create profile from the server response \n" +  msg.to_s
      end
    end

  end

  def create_profile_from_template
    # check if the source template name is a dn name
    prof_dn = resource[:source_template]
    if (! prof_dn.include?('ls-')) ||  (! prof_dn.start_with?('org-'))
      raise Puppet::Error, "Invalid format of source template name. A valid format for source template name is org-root/[sub-organization]/[sub-organization]..../ls-[template name]"
    end

    # check if the template exists
    verify_param = PuppetX::Util::Ciscoucs::NestedHash.new
    verify_param['/configResolveClass'][:cookie] = cookie
    verify_param['/configResolveClass/inFilter/eq'][:value] = prof_dn
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("verifyServiceProfileTemplate")
    verify_temp_request_xml = formatter.command_xml(verify_param)

    if verify_temp_request_xml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML to verify the template"
    end

    verify_temp_response_xml = post verify_temp_request_xml
    if verify_temp_response_xml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the verify template operation."
    end

    # parse and verify template response
    error_msg = ""
    begin
      doc = REXML::Document.new(verify_temp_response_xml)
      if ! doc.elements["/configResolveClass/outConfigs"].has_elements?
        error_msg = "The " + resource[:source_template] + " template does not exist."
      end

      template_dn = doc.elements["/configResolveClass/outConfigs/lsServer"].attributes["dn"]

      if(template_dn != prof_dn)
        error_msg = "The " + resource[:source_template] + " template does not exist."
      end
    rescue
      if error_msg != ""
        raise Puppet::Error, error_msg
      else
        raise Puppet::Error, "Unable to parse the template response XML."
      end
      
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
    parameters['/lsInstantiateNTemplate'][:inTargetOrg] = resource[:organization]
    parameters['/lsInstantiateNTemplate'][:inServerNamePrefixOrEmpty] = resource[:serviceprofile_name]
    parameters['/lsInstantiateNTemplate'][:inNumberOf] = count
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("createServiceProfile")
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for the Create Profile from Template operation."
    end

    responsexml = post requestxml
    disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response for the Create Profile from Template operation."
    end

    #parser response xml to check for errors
    begin
      create_doc = REXML::Document.new(responsexml)
      if create_doc.elements["/error"] &&  create_doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occured while creatng a profile: "+  create_doc.elements["/error"].attributes["errorDescr"]
      elsif create_doc.elements["/lsInstantiateNTemplate"] &&  create_doc.elements["/lsInstantiateNTemplate/outConfigs/lsServer"].attributes["dn"]
        profile_new = create_doc.elements["/lsInstantiateNTemplate/outConfigs/lsServer"].attributes["dn"]
        Puppet.notice("Successfully created profile: " +  profile_new  + " from template: " + resource[:source_template])
      else
        raise Puppet::Error, "Unable to create profile from template: "+  resource[:source_template]
      end
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following error occurred while parsing the Create Profile from the Template response" +  msg.to_s
    end
  end

  def destroy
    Puppet.notice("Method not supported")
  end

  def dn
    profile_dn resource[:serviceprofile_name], resource[:organization], resource[:profile_dn]
  end

  def power_dn
    dn + "/power"
  end

  def exists?
    if ! check_element_exists dn
       if (resource[:power_state])
         msg = "No such profile exists: " + dn
           Puppet.notice (msg)
        disconnect
       end
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
        Puppet.notice ("The power is already in the running state.")
      elsif power == 'down' and resource[:power_state].to_s == 'down'
        Puppet.notice ("The power state is already off.")
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
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("powerOn")
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
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("powerOff")
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
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("VerifyElementExists")
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
