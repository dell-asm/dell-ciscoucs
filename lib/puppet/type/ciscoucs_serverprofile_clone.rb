Puppet::Type.newtype(:ciscoucs_serverprofile_clone) do
  @doc = 'Clone Cisco UCS server profile'
  
  apply_to_device
  ensurable


  newproperty(:enabled) do
    desc 'whether or not power should be enabled'
    newvalues(:true, :false)
    defaultto(:true)
  end



end
