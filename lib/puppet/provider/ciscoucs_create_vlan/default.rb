require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_create_vlan).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Create vlan on Cisco UCS device."
  def create
    Puppet.info "create method call......"
    dn = ""
    if @resource[:fabric_id].strip.length >0
      dn = "fabric/lan/#{@resource[:fabric_id]}/net-#{@resource[:name]}"
    else
      dn = "fabric/lan/net-#{@resource[:name]}"
    end
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("createvlan")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos/inConfigs/pair/fabricVlan'][:dn] = dn
    parameters['/configConfMos/inConfigs/pair'][:key] = dn
    parameters['/configConfMos/inConfigs/pair/fabricVlan'][:id] = @resource[:id]
    parameters['/configConfMos/inConfigs/pair/fabricVlan'][:mcastPolicyName] = @resource[:mcast_policy_name]
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair/fabricVlan'][:name] = @resource[:name]
    if @resource[:sharing].strip.length > 0
      parameters['/configConfMos/inConfigs/pair/fabricVlan'][:sharing] = @resource[:sharing]
    end
    if  @resource[:status].strip.length > 0
      parameters['/configConfMos/inConfigs/pair/fabricVlan'][:status] = @resource[:status]
    end

    createvlanidxml = formatter.command_xml(parameters)
    ucscreatevlanidresp = post createvlanidxml
    createvlanidresponse = REXML::Document.new(ucscreatevlanidresp)
    root = createvlanidresponse.root
    createvlanidresponse.elements.each("/configConfMos/outConfigs/pair/fabricVlan") {
      |e|
      if e.attributes["status"].eql?('created')
        Puppet.notice "vlan created successfully."
      end
    }

    if !root.attributes['errorDescr'].nil?
      raise Puppet::Error, root.attributes['errorDescr']
    end

  end

  def destroy
    #puts "inside destroy method"
  end

  def exists?
    #puts "inside exist method"
  end

end
