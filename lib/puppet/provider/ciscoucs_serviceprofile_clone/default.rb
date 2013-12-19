require 'pathname'
provider_path = Pathname.new(__FILE__).parent.parent
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_clone).provide(:default, :parent => Puppet::Provider::CiscoUCS) do
  @doc = "Clone Cisco UCS service profile."

 

end