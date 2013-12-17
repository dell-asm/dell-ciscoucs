require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serverprofile_clone).provide(:default, :parent => Puppet::Provider::CiscoUCS) do
  @doc = "Clone Cisco UCS server profile."

  def test
    #serverProfilePowerOnXML = '<configConfMo dn="org-root/ls-TestSTN/power" cookie="' + ucsCookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-TestSTN/power" state="admin-up"> </lsPower> </inConfig> </configConfMo>'
    #ucsPowerResp = RestClient.post url, serverProfilePowerOnXML, :content_type => 'text/xml'
    #puts "************Logout Response Start*************"
    #puts "ucsPowerResp " + ucsPowerResp
    
    #serverProfilePowerOffXML = '<configConfMo dn="org-root/ls-TestSTN/power" cookie="' + ucsCookie + '" inHierarchical="false"> <inConfig> <lsPower dn="org-root/ls-TestSTN/power" state="admin-down"> </lsPower> </inConfig> </configConfMo>'
  end


end