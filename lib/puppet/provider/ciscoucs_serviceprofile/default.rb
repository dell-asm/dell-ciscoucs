require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  #confine :feature => :ssh

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    name = resource[:name]
    serverProfilePowerOnXML = '<configConfMo dn="org-root/ls-'+name+'/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-up"> </lsPower> </inConfig> </configConfMo>'
    ucsPowerResp = post serverProfilePowerOnXML
  end

  def destroy
    name = resource[:name]
    serverProfilePowerOffXML = '<configConfMo dn="org-root/ls-'+name+'/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-'+name+'/power" state="admin-down"> </lsPower> </inConfig> </configConfMo>'
    ucsPowerResp = RestClient.post url, serverProfilePowerOffXML, :content_type => 'text/xml'
  end

  def exists?
    #a = resource[:name] ? false : true
    false
    #Puppet.debug "------- output ------" + a.to_s
  end

  def power_state
    Puppet.debug "Getting power state of the Service Profile."
    begin

    rescue Exception => exception
      puts exception.message
    end
  end

  def power_state=(value)
    puts "Setting the power state of service profile."
    begin
      profile_name = resource[:name]
      # power off the service profile
      if value == :down
        
      # power on the service profile
      elsif value == :on

      end

    rescue Exception => exception
      flag = 1
      puts "Unable to perform the operation because the following exception occurred."
      puts exception.message
    end
  end

end
