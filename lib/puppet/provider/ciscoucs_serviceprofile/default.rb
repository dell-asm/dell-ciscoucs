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
    if resource[:source_template].to_s.strip.length == 0
      # create profile from server
      create_profile_from_server
    else
      # create profile from template
      create_profile_from_template
    end
  end

  def create_profile_from_server

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
      raise Puppet::Error, "Cannot create request xml to verify template"
    end
    Puppet.debug "Sending request xml: \n" + verify_temp_request_xml
    verify_temp_response_xml = post verify_temp_request_xml
    if verify_temp_response_xml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from verify template"
    end
    Puppet.debug "Response from verify template: \n" + verify_temp_response_xml
    # parse and verify template response
    doc = REXML::Document.new(verify_temp_response_xml)
    begin
      if ! doc.elements["/configResolveClass/outConfigs"].has_elements?
        raise Puppet::Error, "No such template exists: "+ resource[:source_template]
      end

      template_dn = doc.elements["/configResolveClass/outConfigs/lsServer"].attributes["dn"]

      if(template_dn != prof_dn)
        raise Puppet::Error, "No such template exists: "+ resource[:source_template]
      end
    rescue
      raise Puppet::Error, "Error parsing xml"
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
      raise Puppet::Error, "Cannot create request xml for create profile from template operation"
    end
    Puppet.debug "Sending create profile from template request xml: \n" + requestxml
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from create profile from template operation"
    end
    Puppet.debug "Response from create profile from template: \n" + responsexml

    #parser response xml to check for errors
    create_doc = REXML::Document.new(responsexml)
    if create_doc.elements["/error"] &&  create_doc.elements["/error"].attributes["errorCode"]
      raise Puppet::Error, "Following error occured while creatng profile : "+  create_doc.elements["/error"].attributes["errorDescr"]

    else
      Puppet.info("Successfully created profile "+ resource[:name]+ " from template " + resource[:source_template])
    end
  end

  def destroy
    # todo: delete profile
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
