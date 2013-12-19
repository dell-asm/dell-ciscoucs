require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serverprofile_power).provide(:default, :parent => Puppet::Provider::CiscoUCS) do
  @doc = "Manage Association of server profile on Cisco UCS."
  

  def create
    cookie
    serverProfilePowerOnXML = '<configConfMo dn="org-root/ls-TestSTN/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-TestSTN/power" state="admin-up"> </lsPower> </inConfig> </configConfMo>'
    puts serverProfilePowerOnXML
    
    ucsPowerResp = RestClient.post url, serverProfilePowerOnXML, :content_type => 'text/xml'
    
    
    puts "ucsPowerResp " + ucsPowerResp
  end

  def destroy
    cookie      
      serverProfilePowerOffXML = '<configConfMo dn="org-root/ls-TestSTN/power" cookie="' + cookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-TestSTN/power" state="admin-down"> </lsPower> </inConfig> </configConfMo>'
      puts serverProfilePowerOffXML
      
      ucsPowerResp = RestClient.post url, serverProfilePowerOffXML, :content_type => 'text/xml'
            
      puts "ucsPowerResp " + ucsPowerResp
    end
end