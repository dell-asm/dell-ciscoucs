require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

#ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
$order_array = Hash.new


Puppet::Type.type(:ciscoucs_vlan_vnic_template).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  include PuppetX::Puppetlabs::Transportciscoucs
  @doc = "Update VLAN in vNIC template Cisco UCS device."
  def create
    source_profile_dn = "#{@resource[:vnictemplateorg]}/lan-conn-templ-#{@resource[:name]}"
    source_profile_rn = "if-#{@resource[:vlan_name]}"
    vlanList = populatevlan(source_profile_dn,@resource[:vlan_name],@resource[:defaultnet])
    xml_content = xml_template "updateVLANVNICTemplate"
    temp_doc = REXML::Document.new(xml_content)
    policyElem = temp_doc.elements["/configConfMos/inConfigs/pair/vnicLanConnTempl"]
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("updateVLANVNICTemplate")
    updateparameters = PuppetX::Util::Ciscoucs::NestedHash.new
    updateparameters['/configConfMos'][:cookie] = cookie
    updateparameters['/configConfMos/inConfigs/pair'][:key] = "#{source_profile_dn}"
    updateparameters['/configConfMos/inConfigs/pair/vnicLanConnTempl'][:dn] = "#{source_profile_dn}"
    if (vlanList.include?("#{@resource[:vlan_name]}") && "#{@resource[:defaultnet]}" == "no")
      policyElem.add_element 'vnicEtherIf', {'rn' => "if-#{@resource[:vlan_name]}", 'defaultNet' => $order_array["#{@resource[:vlan_name]}"], 'name' => "#{@resource[:vlan_name]}"}
    else
      if (!vlanList.include? "#{@resource[:vlan_name]}")
        vlanList.push("#{@resource[:vlan_name]}")
      end
      vlanList.each do |vlan|
        policyElem.add_element 'vnicEtherIf', {'rn' => "if-#{vlan}", 'defaultNet' => $order_array["#{vlan}"], 'name' => "#{vlan}"}
      end
    end

    temp_file_path = File.join xml_template_path, "temp_update_vlan_vnic_template"
    temp_file_path+= ".xml"
    File.open(temp_file_path,"w") do |data|
      data<<temp_doc
    end
    temp_formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("temp_update_vlan_vnic_template")
    temp_requestxml = temp_formatter.command_xml(updateparameters);
    Puppet.debug("#{temp_requestxml}")
    temp_responsexml = post temp_requestxml
    if temp_responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get response from the Update VLAN in vNIC Template operation."
    end
    Puppet.debug("#{temp_responsexml}")
    # delete temporary xml file
    File.delete(temp_file_path) if File.exist?(temp_file_path)
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

  def destroy
    # not needed
  end

  def populatevlan(dn,vlanname,defaultnet)
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="' + dn + '" '"inHierarchical=true"'/>'
    responsexml = post request_xml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from vnic template"
    end
    vlanlist = Array.new
    spresponse = REXML::Document.new(responsexml)
    root = spresponse.root
    spresponse.elements.each("/configResolveDn/outConfig/vnicLanConnTempl/vnicEtherIf") {
      |e|
      vlanName = "#{e.attributes["name"]}"
      defnet = "#{e.attributes["defaultNet"]}"
      if (!"#{vlanName}".eql?("#{vlanname}"))
        if ("#{defnet}".eql?("#{defaultnet}"))
          if ("#{defaultnet}" == "yes")
            defnet = "no"
          end

        end
      end
      $order_array[e.attributes["name"]] = "#{defnet}"
      vlanlist.push(vlanName)
    }
    $order_array[@resource[:vlan_name]] = "#{@resource[:defaultnet]}"
    vlanlist
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

  def checkvnictemplate
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("verifyVNICTemplate")
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
        source_profile_dn = "#{@resource[:vnictemplateorg]}/lan-conn-templ-#{@resource[:name]}"
        if check_vlan_exist_vnic_template(source_profile_dn,@resource[:vlan_name],@resource[:defaultnet])
          Puppet.debug("VLAN already updated in vNIC Template")
          return true
        else
          return false
        end
      end
    end
  end

end

