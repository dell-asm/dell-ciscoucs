require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/Xmlformatter'

Puppet::Type.type(:ciscoucs_vlan_serviceprofile).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  include PuppetX::Puppetlabs::Transportciscoucs
  @doc = "Update VLAN in Service Profile Cisco UCS device."
  def create
    source_profile_dn = "#{@resource[:serviceprofileorg]}/ls-#{@resource[:name]}/ether-#{@resource[:vnic]}"
    source_profile_rn = "if-#{resource[:vlan_name]}"
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("updateVLANServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos/inConfigs/pair/vnicEther'][:dn] = "#{source_profile_dn}"
    parameters['/configConfMos/inConfigs/pair/vnicEther/vnicEtherIf'][:defaultNet] = @resource[:defaultnet]
    parameters['/configConfMos/inConfigs/pair/vnicEther/vnicEtherIf'][:name] = @resource[:vlan_name]
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = "#{source_profile_dn}"
    parameters['/configConfMos/inConfigs/pair/vnicEther/vnicEtherIf'][:rn] = "#{source_profile_rn}"
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for update vlan service profile operation"
    end
    Puppet.debug "Sending update vlan service profile request xml: \n" + requestxml
    responsexml = post requestxml
    disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from  update vlan service profile"
    end
    Puppet.debug "Response from  update vlan service profile: \n" + responsexml
    updatevlanidresponse = REXML::Document.new(responsexml)
    root = updatevlanidresponse.root
    updatevlanidresponse.elements.each("/configConfMos/outConfigs/pair/vnicEther") {
      |e|
      if e.attributes["status"].eql?('modified')
        Puppet.notice "Vlan updated successfully in Service Profile."
      elsif e.attributes["status"].eql?('created')
        Puppet.notice "Vlan updated successfully in newly created Service Profile."
      else
        raise Puppet::Error, "Unable to update VLAN in Service Profile"
      end
    }

    if !root.attributes['errorDescr'].nil?
      raise Puppet::Error, root.attributes['errorDescr']
    end

  end

  def destroy
    # not needed
  end

  def checkvlan
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("verifyVLAN")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass/inFilter/eq'][:value] = @resource[:vlan_name]
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for verify vlan operation"
    end
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from  verify vlan"
    end
    doc = REXML::Document.new(responsexml)
    if doc.elements["/configResolveClass/outConfigs"].has_elements?
      return true
    else
      raise Puppet::Error, "VLAN does not exist"
    end

  end

  def checkvnic
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("verifyVnic")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass/inFilter/eq'][:value] = "#{@resource[:serviceprofileorg]}/ls-#{@resource[:name]}/ether-#{@resource[:vnic]}"
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for verify vnic operation"
    end
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from  verify vnic"
    end
    doc = REXML::Document.new(responsexml)
    if doc.elements["/configResolveClass/outConfigs"].has_elements?
      return true
    else
      raise Puppet::Error, "vNIC does not exist"
    end

  end

  def exists?
    # check if the source profile exists
    if checkvlan
      if checkvnic
        source_profile_dn = "#{@resource[:serviceprofileorg]}/ls-#{@resource[:name]}"
        if check_vlan_exist_service_profile(source_profile_dn,@resource[:vlan_name],@resource[:defaultnet])
          Puppet.debug("VLAN already updated in service profile")
          return true
        else
          return false
        end
      end
    end
  end

end

