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

  def exists?
    # check if the source profile exists
      return false
  end

end

