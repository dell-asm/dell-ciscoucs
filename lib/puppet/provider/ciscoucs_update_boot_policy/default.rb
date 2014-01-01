require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_update_boot_policy).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    # check if the boot policy exists
    if ! check_boot_policy_exists policy_dn
      raise Puppet::Error, "No such boot policy exits " + policy_dn
    end

    # question: do we need to verify, if the policy is already associated with template
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("updateBootPolicy")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos/inConfigs/pair/lsServer'][:bootPolicyName] = resource[:bootpolicyname]
    parameters['/configConfMos/inConfigs/pair'][:key] = resource[:dn]
    parameters['/configConfMos'][:cookie] = cookie

    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for update boot policy operation"
    end
    Puppet.debug "Sending update boot policy request xml: \n" + requestxml
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from update boot policy operation"
    end
    Puppet.debug "Response from update boot policy: \n" + responsexml

    #parser response xml to check for errors
    begin
      doc = REXML::Document.new(responsexml)

      if doc.elements["/error"] &&  doc.elements["/error"].attributes["errorCode"]
        raise Puppet::Error, "Following error occurred while updating boot policy : "+  doc.elements["/error"].attributes["errorDescr"]
        #elsif doc.elements["/lsClone"] &&  doc.elements["/lsClone"].attributes["errorCode"]
        # raise Puppet::Error, "Following error occurred while cloning profile : "+  doc.elements["/lsClone"].attributes["errorDescr"]
        #elsif doc.elements["/lsClone/outConfig/lsServer"] &&  doc.elements["/lsClone/outConfig/lsServer"].attributes["status"].eql?('created')
        # Puppet.info("Successfully updated boot policy "+ resource[:bootpolicyname])
      else
        raise Puppet::Error, "Unable to update boot policy " + resource[:bootpolicyname]
      end
    rescue Exception => msg
      raise Puppet::Error, "Following error occurred while parsing modify boot policy response" +  msg.to_s
    end
  end

  def destroy
    # not needed
  end

  def policy_dn
    target_dn = ""
    if (resource[:bootpolicyname] && resource[:bootpolicyname].strip.length > 0) &&
    (resource[:organization] && resource[:organization].strip.length > 0)
      policy_name = resource[:bootpolicyname]
      if ! policy_name.start_with?('boot-policy-')
        policy_name= "boot-policy-" + policy_name
      end
      target_dn = resource[:organization] +"/"+ policy_name
    elsif (resource[:dn] && resource[:dn].strip.length > 0)
      target_dn = resource[:dn]
    end
    return target_dn
  end

  def exists?
    # check if the source profile exists
    if check_profile_exists resource[:dn]
      # source profile exists, execute update service profile operation
      return false
    end
    # error
    #todo : check the ensure value before sending the error
    raise Puppet::Error, "No such profile exists " + service_profile_dn
  end

end

