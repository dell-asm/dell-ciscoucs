# "This is base class for ciscoucs"

require 'rest-client'

module_lib = Pathname.new(__FILE__).parent.parent.parent
require File.join module_lib.to_s, '/puppet_x/puppetlabs/transport'
require  File.join module_lib.to_s, '/puppet_x/puppetlabs/transport/ciscoucs'

=begin

begin
  require 'puppet_x/puppetlabs/transport'
rescue LoadError => error
  require 'pathname'
  ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
  require File.join ucs_module.path, 'lib/puppet_x/puppetlabs/transport'
end

begin
  require 'puppet_x/puppetlabs/transport/ciscoucs'
rescue LoadError => error
  require 'pathname'
  module_lib = Pathname.new(__FILE__).parent.parent.parent
  require File.join module_lib, 'puppet_x/puppetlabs/transport/ciscoucs'
end

=end

class Puppet::Provider::Ciscoucs < Puppet::Provider
  def cookie
    @transport ||= PuppetX::Puppetlabs::Transport.retrieve(:resource_ref => resource[:transport], :catalog => resource.catalog, :provider => 'ciscoucs')
    value = @transport.cookie
    value.to_s
  end

  def url
    @transport.url
  end

  def disconnect
    @transport.close
  end

  def check_profile_exists(dn)
    formatter = PuppetX::Util::Ciscoucs::xmlformatter.new("VerifyElementExists")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveDn'][:cookie] = cookie
    parameters['/configResolveDn'][:dn] = dn

    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for checking profile"
    end
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from check profile"
    end
    begin
      doc = REXML::Document.new(responsexml)
      return doc.elements["/configResolveDn/outConfig"].has_elements?
    rescue Exception => msg
      raise Puppet::Error, "Following error occurred while parsing check profile response" +  msg.to_s
    end
  end

  def check_vlan_exist(dn)
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="' + dn + '" />'
    response_xml = post request_xml
    doc = REXML::Document.new(response_xml)
    if doc.elements["/configResolveDn/outConfig"].has_elements?
      return true
    else
      return false
    end
  end

  def check_vlan_exist_service_profile(dn,vlanname,defaultnet)
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="' + dn + '" '"inHierarchical=true"'/>'
    responsexml = post request_xml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from service profile"
    end
    vlanFound = false
    defaultNetFound = false
    spresponse = REXML::Document.new(responsexml)
    root = spresponse.root
    spresponse.elements.each("/configResolveDn/outConfig/lsServer/vnicEther/vnicEtherIf") {
      |e|

      if (!e.attributes["name"].eql?("#{vlanname}"))
        next
      end

      if ( e.attributes["name"].eql?("#{vlanname}"))
        vlanFound = true
      end

      if ( e.attributes["defaultNet"].eql?("#{defaultnet}"))
        defaultNetFound = true
      end

    }

    if (vlanFound == true && defaultNetFound == true)
      return true
    else
      return false
    end

  end

  def check_vlan_exist_vnic_template(dn,vlanname,defaultnet)
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="' + dn + '" '"inHierarchical=true"'/>'
    responsexml = post request_xml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from vnic template"
    end
    vlanFound = false
    defaultNetFound = false
    spresponse = REXML::Document.new(responsexml)
    root = spresponse.root
    spresponse.elements.each("/configResolveDn/outConfig/vnicLanConnTempl/vnicEtherIf") {
      |e|

      if (!e.attributes["name"].eql?("#{vlanname}"))
        next
      end

      if ( e.attributes["name"].eql?("#{vlanname}"))
        vlanFound = true
      end

      if ( e.attributes["defaultNet"].eql?("#{defaultnet}"))
        defaultNetFound = true
      end

    }

    if (vlanFound == true && defaultNetFound == true)
      return true
    else
      return false
    end

  end

  def check_boot_policy_exists(dn)
    formatter = PuppetX::Util::Ciscoucs::xmlformatter.new("verifyBootPolicy")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass/inFilter/eq'][:value] = dn

    requestxml = formatter.command_xml(parameters)
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Cannot create request xml for checking boot policy"
    end
    responsexml = post requestxml
    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "No response obtained from check boot policy"
    end
    begin
      doc = REXML::Document.new(responsexml)

      if ! doc.elements["/configResolveClass/outConfigs"].has_elements?
        return false
      end

      policy_dn = doc.elements["/configResolveClass/outConfigs/lsbootPolicy"].attributes["dn"]

      if(policy_dn != dn)
        return false
      end
    rescue Exception => msg
      raise Puppet::Error, "Following error occurred while parsing check boot policy response" +  msg.to_s
    end
    return true

  end

  # Helper function for execution of Cisco UCS API commands
  def post(request_xml)
    begin
      result ||= RestClient.post url, request_xml, :content_type => 'text/xml'
    rescue RestClient::Exception => error
      #Puppet.debug "Failed REST #{m} to URL #{url}:\nXML Format:\n#{request_xml}"
      raise Puppet::Error, "\n#{error.exception}:\n#{error.response}"
    end
    #Puppet.debug "Cisco UCS Post: #{url} \n Request:\n#{request_xml} Response:\n#{result.inspect}"

  end
end

