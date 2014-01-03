require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/Xmlformatter'

Puppet::Type.type(:ciscoucs_modify_lan_bootorder).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

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
    puts requestxml
    responsexml = post requestxml
    puts responsexml
    #disconnect
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get response from the Modify Boot Policy order operation."
    end

    rn = Array.new
    begin
      doc = REXML::Document.new(responsexml)
      if !doc.elements["/configResolveClass/outConfigs/lsbootPolicy"]
        raise Puppet::Error, "Invalid response from the Modify Boot Policy order operation."
      end
      boot_element = doc.elements["/configResolveClass/outConfigs/lsbootPolicy"]

      if boot_element.elements["lsbootLan"]
        lanorder = boot_element.elements["lsbootLan"].attributes["order"]
        rn[lanorder.to_i-1] = "lan"
      end
      if boot_element.elements["lsbootStorage"]
        sanorder = boot_element.elements["lsbootStorage"].attributes["order"]
        rn[sanorder.to_i-1] = "storage"
      end
      if boot_element.elements["lsbootIScsi"]
        iscsiorder = boot_element.elements["lsbootIScsi"].attributes["order"]
        rn[iscsiorder.to_i-1] = "iscsi"
      end
      if boot_element.elements["lsbootVirtualMedia"] && boot_element.elements["lsbootVirtualMedia"].attributes["type"].eql?('virtual-media')
        boot_element.elements.each("lsbootVirtualMedia") {
          |media|
          rn = media.attributes["rn"]
          if rn=="read-write-vm"
            worder = media.attributes["order"]
            rn[worder.to_i-1] = "read-write-vm"
          end
          if rn=="read-only-vm"
            rorder = media.attributes["order"]
            rn[rorder.to_i-1] = "read-only-vm"
          end
        }
      end
    rescue Exception => msg
      raise Puppet::Error, "Unable to perform the operation because the following issue occurred while parsing the Modify Boot Policy order response. " +  msg.to_s
    end

    # re-ordering
    lancurorder=rn.find_index { |e| e.match( /lan/ ) }.to_i
    rn.insert(resource[:lanorder].to_i-1, rn.delete_at(lancurorder.to_i))

    xml_content = xml_template "updateBootPolicyOrder"
    temp_doc = REXML::Document.new(xml_content)
    policyElem = temp_doc.elements["/configConfMos/inConfigs/pair/lsbootPolicy"]
    updateparameters = PuppetX::Util::Ciscoucs::NestedHash.new
    updateparameters['/configConfMos'][:cookie] = cookie
    updateparameters['/configConfMos/inConfigs/pair'][:key] = boot_policy_dn
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy'][:dn] = boot_policy_dn

    for elm in rn do
      if elm == "iscsi"
        policyElem.add_element 'lsbootIScsi', {'rn' => '', 'order' => ''}
        updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:rn] = "iscsi"
        updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:order] = rn.find_index { |e| e.match( /iscsi/ ) }.to_i + 1
      end
      if elm == "lan"
        policyElem.add_element 'lsbootLan', {'rn' => '', 'order' => ''}
        updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootLan'][:rn] = "lan"
        updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootLan'][:order] = rn.find_index { |e| e.match( /lan/ ) }.to_i + 1
      end
      if elm == "storage"
        policyElem.add_element 'lsbootStorage', {'rn' => '', 'order' => ''}
        updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootStorage'][:rn] = "storage"
        updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootStorage'][:order] = rn.find_index { |e| e.match( /storage/ ) }.to_i + 1
      end
      #if elm == "read-write-vm"
      # policyElem.add_element 'lsbootVirtualMedia', {'rn' => '', 'order' => ''}
      # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:rn] = "iscsi"
      # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:order] = rn.find_index { |e| e.match( /iscsi/ ) }.to_i
      #end
      #if elm == "read-only-vm"
      # policyElem.add_element 'lsbootVirtualMedia', {'rn' => '', 'order' => ''}
      # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:rn] = "iscsi"
      # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:order] = rn.find_index { |e| e.match( /iscsi/ ) }.to_i
      #end
    end

    temp_file_path = File.join xml_template_path, "temp_update_boot_policy"
    temp_file_path+= ".xml"
    File.open(temp_file_path,"w") do |data|
      data<<temp_doc
    end

      temp_formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("temp_update_boot_policy")
      temp_requestxml = temp_formatter.command_xml(updateparameters);

      temp_responsexml = post temp_requestxml

      # todo: delete temporary xml file
      # todo: order exceed the limit

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
      if (resource[:bootpolicyname] && resource[:bootpolicyname].strip.length > 0) &&
      (resource[:organization] && resource[:organization].strip.length > 0)
        policy_name = resource[:bootpolicyname]
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
      puts  "1"
      if check_boot_policy_exists boot_policy_dn
      puts  "2"
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
