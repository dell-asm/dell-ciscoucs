require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/Xmlformatter'

Puppet::Type.type(:ciscoucs_serviceprofile_boot_order).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Update order in boot policy."
  def create
    # get the current boot order
    # re-order
    # update boot orders as per re-ordering
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("updatelanBootOrderPolicy")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass/inFilter/eq'][:value] = boot_policy_dn
    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create the request XML for the Modify Boot Policy order operation."
    end
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get response from the Modify Boot Policy order operation."
    end

    order_array = Array.new

    begin
      doc = REXML::Document.new(responsexml)
      if !doc.elements["/configResolveClass/outConfigs/lsbootPolicy"]
        raise Puppet::Error, "Invalid response from the Modify Boot Policy order operation."
      end

      doc.elements.each("/configResolveClass/outConfigs/lsbootPolicy/") { |element|
        if element.elements["lsbootLan"]
          lanorder = element.elements["lsbootLan"].attributes["order"]
          order_array[lanorder.to_i-1] = "lan"
        end
        if element.elements["lsbootStorage"]
          sanorder = element.elements["lsbootStorage"].attributes["order"]
          order_array[sanorder.to_i-1] = "storage"
        end
        if element.elements["lsbootIScsi"]
          iscsiorder = element.elements["lsbootIScsi"].attributes["order"]
          order_array[iscsiorder.to_i-1] = "iscsi"
        end
        if element.elements["lsbootVirtualMedia"] && element.elements["lsbootVirtualMedia"].attributes["type"].eql?('virtual-media')
          element.elements.each("lsbootVirtualMedia") {
            |media|
            rn1 = media.attributes["rn"]
            if rn1 == "read-write-vm"
              worder = media.attributes["order"]
              order_array[worder.to_i-1] = "read-write-vm"
            end
            if rn1 == "read-only-vm"
              rorder = media.attributes["order"]
              order_array[rorder.to_i-1] = "read-only-vm"
            end
          }
        end
      }
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following issue occurred while parsing the Modify Boot Policy order response. " +  msg.to_s
    end

    # check if lan boot order is already same
    lancurorder = order_array.find_index { |e| e.match( /lan/ ) }.to_i
    if lancurorder+1 == resource[:lan_order].to_i
      raise Puppet::Error, "LAN order is already "+ resource[:lan_order]
    end
    # re-ordering
    order_array.insert(resource[:lan_order].to_i-1, order_array.delete_at(lancurorder.to_i))

    xml_content = xml_template "updateBootPolicyOrder"
    temp_doc = REXML::Document.new(xml_content)
    policyElem = temp_doc.elements["/configConfMos/inConfigs/pair/lsbootPolicy"]
    updateparameters = PuppetX::Util::Ciscoucs::NestedHash.new
    updateparameters['/configConfMos'][:cookie] = cookie
    updateparameters['/configConfMos/inConfigs/pair'][:key] = boot_policy_dn
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy'][:dn] = boot_policy_dn

    for elm in order_array do
      case (elm)
      when "iscsi"
        policyElem.add_element 'lsbootIScsi', {'rn' => 'iscsi', 'order' => order_array.find_index { |e| e.match( /iscsi/ ) }.to_i + 1}
      when "lan"
        policyElem.add_element 'lsbootLan', {'rn' => 'lan', 'order' => order_array.find_index { |e| e.match( /lan/ ) }.to_i + 1}
      when "storage"
        policyElem.add_element 'lsbootStorage', {'rn' => 'storage', 'order' => order_array.find_index { |e| e.match( /storage/ ) }.to_i + 1}
      when "read-write-vm"
        policyElem.add_element 'lsbootVirtualMedia', {'rn' => 'read-write-vm', 'order' =>  order_array.find_index { |e| e.match( /read-write-vm/ ) }.to_i + 1}
      when "read-only-vm"
        policyElem.add_element 'lsbootVirtualMedia', {'rn' => 'read-only-vm', 'order' =>  order_array.find_index { |e| e.match( /read-only-vm/ ) }.to_i + 1 }
      end
      
     
    end



    temp_file_path = File.join xml_template_path, "temp_update_boot_policy"
    temp_file_path+= ".xml"
    File.open(temp_file_path,"w") do |data|
      data<<temp_doc
    end

    temp_formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("temp_update_boot_policy")
    temp_requestxml = temp_formatter.command_xml(updateparameters);
    temp_responsexml = post temp_requestxml
    if temp_responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get response from the Modify Boot Policy order operation."
    end
    # delete temporary xml file
    File.delete(temp_file_path) if File.exist?(temp_file_path)
    Puppet.notice("Successfully modified the Lan Boot Order Policy: "+ boot_policy_dn)
    # disconnect cookie
    disconnect
  end

  def xml_template_path
    module_lib = Pathname.new(__FILE__).parent.parent.parent.parent
    File.join module_lib.to_s, '/puppet_x/util/ciscoucs/xml'
  end

  def xml_template (filename)
    content = ""
    xml_path = File.join xml_template_path, filename
    xml_path+= ".xml"
    if File.exists?(xml_path)
      # read file in block will close the file handle internally when block terminates
      content = File.open(xml_path, 'r') { |file| file.read }
    else
      raise Puppet::Error, "Cannot read xml template from location: " + xml_path
    end
    return content
  end

  def boot_policy_dn
    policy_dn = ""
    if (resource[:bootpolicy_name] && resource[:bootpolicy_name].strip.length > 0) &&
    (resource[:organization] && resource[:organization].strip.length > 0)
      policy_name = resource[:bootpolicy_name]
      if ! policy_name.start_with?('boot-policy-')
        policy_name= "boot-policy-" + policy_name
      end
      policy_dn = resource[:organization] +"/"+ policy_name
    elsif (resource[:dn] && resource[:dn].strip.length > 0)
      policy_dn = resource[:dn]
    end
    return policy_dn
  end

  def exists?
    # check if the boot policy exists
    if check_boot_policy_exists boot_policy_dn
      # check the ensure input value
      if (resource[:ensure].to_s =="present")
        return false;
      end
      return true;
    end
    # error
    raise Puppet::Error, "The " + boot_policy_dn + " boot policy does not exist."
  end
end
