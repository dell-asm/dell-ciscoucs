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
    # split the target dn to get the org name and clone name
    str = target_profile_dn
    targetprofileorg = str.split("/ls-").first
    clonename = str.split("ls-").last

    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("createServiceProfileClone")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/lsClone'][:dn] = source_profile_dn
    parameters['/lsClone'][:inTargetOrg] = targetprofileorg
    parameters['/lsClone'][:inServerName] = clonename
    parameters['/lsClone'][:cookie] = cookie
    parameters['/lsClone'][:inHierarchical] = 'false'
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for clone profile operation"
    end
    Puppet.debug "Sending clone profile request xml: \n" + requestxml
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from clone profile operation"
    end
    Puppet.debug "Response from clone profile: \n" + responsexml

    #parser response xml to check for errors
    begin
      doc = REXML::Document.new(responsexml)
      if doc.elements["/error"] &&  doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Following error occurred while cloning profile : "+  doc.elements["/error"].attributes["errorDescr"]
      elsif doc.elements["/lsClone"] &&  doc.elements["/lsClone"].attributes["errorCode"]
        raise Puppet::Error, "Following error occurred while cloning profile : "+  doc.elements["/lsClone"].attributes["errorDescr"]
      elsif doc.elements["/lsClone/outConfig/lsServer"] &&  doc.elements["/lsClone/outConfig/lsServer"].attributes["status"].eql?('created')
        Puppet.info("Successfully cloned profile "+ clonename)
      else
        raise Puppet::Error, "Unable to clone profile " + clonename
      end
    rescue Exception => msg
      raise Puppet::Error, "Following error occurred while parsing clone profile response" +  msg.to_s
    end
  end

  def destroy
    Puppet.notice("Method not supported")
  end

  def target_profile_dn
    target_dn = ""
    if (resource[:targetserviceprofilename] && resource[:targetserviceprofilename].strip.length > 0) &&
    (resource[:targetorganization] && resource[:targetorganization].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:targetserviceprofilename]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      target_dn = resource[:targetorganization] +"/"+ profile_name
    elsif (resource[:targetprofiledn] && resource[:targetprofiledn].strip.length > 0)
      target_dn = resource[:targetprofiledn]
    end
    return target_dn
  end

  def source_profile_dn
    source_dn = ""
    if (resource[:sourceserviceprofilename] && resource[:sourceserviceprofilename].strip.length > 0) &&
    (resource[:sourceorganization]  && resource[:sourceorganization].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:sourceserviceprofilename]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      source_dn = resource[:sourceorganization] +"/"+ profile_name
    elsif (resource[:sourceprofiledn] && resource[:sourceprofiledn].strip.length > 0)
      source_dn = resource[:sourceprofiledn]
    end
    return source_dn
  end

  def exists?
    # check if the source profile exists
    if check_profile_exists source_profile_dn
      # source profile exists, execute clone operation
      return false
    end
    # error
    raise Puppet::Error, "No such profile exists " + source_profile_dn
  end

end

