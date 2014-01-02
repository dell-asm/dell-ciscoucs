require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_update_vlan_vnic_template).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  include PuppetX::Puppetlabs::Transport
  @doc = "Update VLAN in vNIC template Cisco UCS device."
  def create
    source_profile_dn = "#{@resource[:vnictemplateorg]}/lan-conn-templ-#{@resource[:name]}"
    source_profile_rn = "if-#{resource[:vlanname]}"
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("updateVLANVNICTemplate")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos/inConfigs/pair/vnicLanConnTempl'][:dn] = "#{source_profile_dn}"
    parameters['/configConfMos/inConfigs/pair/vnicLanConnTempl/vnicEtherIf'][:defaultNet] = @resource[:defaultnet]
    parameters['/configConfMos/inConfigs/pair/vnicLanConnTempl/vnicEtherIf'][:name] = @resource[:vlanname]
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = "#{source_profile_dn}"
    parameters['/configConfMos/inConfigs/pair/vnicLanConnTempl/vnicEtherIf'][:rn] = "#{source_profile_rn}"
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for update vlan vnic template operation"
    end
    Puppet.debug "Sending update vlan vnic template request xml: \n" + requestxml
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from  update vlan vnic template"
    end
    Puppet.debug "Response from  update vlan vnic template: \n" + responsexml
    updatevlanidresponse = REXML::Document.new(responsexml)
    root = updatevlanidresponse.root
    updatevlanidresponse.elements.each("/configConfMos/outConfigs/pair/vnicLanConnTempl") {
      |e|
      if e.attributes["status"].eql?('modified')
        Puppet.notice "Vlan updated successfully in vNIC Template."
      elsif e.attributes["status"].eql?('created')
        Puppet.notice "Vlan updated successfully in newly created vNIC Template."
      else
        raise Puppet::Error, "Unable to update VLAN in vNIC Template"
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
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("verifyVLAN")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass/inFilter/eq'][:value] = @resource[:vlanname]
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

  def checkvnictemplate
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("verifyVNICTemplate")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass/inFilter/eq'][:value] = @resource[:name]
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for verify vnic template operation"
    end
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from  verify vnic template"
    end
    doc = REXML::Document.new(responsexml)
    if doc.elements["/configResolveClass/outConfigs"].has_elements?
      return true
    else
      raise Puppet::Error, "vNIC Template does not exist"
    end
  end

  def exists?
    # check if the source profile exists
    if checkvlan
      if checkvnictemplate
        source_profile_dn = ""#{@resource[:vnictemplateorg]}/lan-conn-templ-#{@resource[:name]}""
        if check_vlan_exist_vnic_template(source_profile_dn,@resource[:vlanname],@resource[:defaultnet])
          Puppet.debug("VLAN already updated in vNIC Template")
          return true
        else
          return false
        end
      end
    end
  end

end

