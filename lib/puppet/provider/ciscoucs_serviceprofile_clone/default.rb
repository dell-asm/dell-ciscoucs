require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/Xmlformatter'

Puppet::Type.type(:ciscoucs_serviceprofile_clone).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transportciscoucs
  @doc = "Clone service profile on cisco ucs device."
  def create
    # split the target dn to get the org name and clone name
    str = target_profile_dn
    targetprofileorg = str.split("/ls-").first
    clonename = str.split("ls-").last

    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("createServiceProfileClone")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/lsClone'][:dn] = source_profile_dn
    parameters['/lsClone'][:inTargetOrg] = targetprofileorg
    parameters['/lsClone'][:inServerName] = clonename
    parameters['/lsClone'][:cookie] = cookie
    parameters['/lsClone'][:inHierarchical] = 'false'
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML for the Clone Profile operation."
    end
    
    responsexml = post requestxml
    disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the Clone Profile operation."
    end
    

    #parser response xml to check for errors
    begin
      doc = REXML::Document.new(responsexml)
      if doc.elements["/error"] &&  doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occurred while cloning the profile: "+  doc.elements["/error"].attributes["errorDescr"]
      elsif doc.elements["/lsClone"] &&  doc.elements["/lsClone"].attributes["errorCode"]
        raise Puppet::Error, "Unable to perform the operation because the following issue occurred while cloning the profile: "+  doc.elements["/lsClone"].attributes["errorDescr"]
      elsif doc.elements["/lsClone/outConfig/lsServer"] &&  doc.elements["/lsClone/outConfig/lsServer"].attributes["status"].eql?('created')
        Puppet.notice("Successfully cloned the profile: "+ clonename)
      else
        raise Puppet::Error, "Unable to clone the profile: " + clonename
      end
    end
  end

  def destroy
    Puppet.notice("Method not supported")
  end

  def target_profile_dn
    profile_dn resource[:target_serviceprofile_name], resource[:target_organization], resource[:target_profile_dn]
  end

  def source_profile_dn
    profile_dn resource[:source_serviceprofile_name], resource[:source_organization], resource[:source_profile_dn]
  end

  def exists?
    # check if the source profile exists
    if check_element_exists source_profile_dn
      # source profile exists, execute clone operation
      return false
    end
    # error
    raise Puppet::Error, "The " + source_profile_dn + " service profile does not exist."
  end

end

