require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    request_xml = '<configConfMo dn="org-root/ls-'+resource[:name]+'/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-up"> </lsPower> </inConfig> </configConfMo>'
    Puppet.debug "Sending power on request: \n" + request_xml
    response_xml = post request_xml
    Puppet.debug "Response from power on: \n" + response_xml
  end

  def destroy
    request_xml = '<configConfMo dn="org-root/ls-'+resource[:name]+'/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-down"> </lsPower> </inConfig> </configConfMo>'
    Puppet.debug "Sending power off request: \n" + request_xml
    response_xml = post request_xml
    Puppet.debug "Response from power off: \n" + response_xml
  end

  def exists?
    request_xml = '<configResolveDn cookie="'+cookie+'"dn="org-root/ls-'+resource[:name]+'" />'
    response_xml = post request_xml
    doc = REXML::Document.new(response_xml)
    root = doc.root
    value  = doc.elements["/configResolveDn/outConfig"].has_elements?
  end

  #  def power_state
  #    Puppet.debug "Getting power state of the Service Profile."
  #    begin
  #
  #    rescue Exception => exception
  #      puts exception.message
  #    end
  #  end
  #
  #  def power_state=(value)
  #    puts "Setting the power state of service profile."
  #    begin
  #      profile_name = resource[:name]
  #      # power off the service profile
  #      if value == :down
  #
  #        # power on the service profile
  #      elsif value == :on
  #
  #      end
  #
  #    rescue Exception => exception
  #      flag = 1
  #      puts "Unable to perform the operation because the following exception occurred."
  #      puts exception.message
  #    end
  #  end

end
