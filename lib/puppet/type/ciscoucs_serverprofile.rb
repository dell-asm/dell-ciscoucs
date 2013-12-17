Puppet::Type.newtype(:ciscoucs_serverprofile) do
  @doc = 'Create server profile on cisco ucs device'
  
  apply_to_device
  ensurable


  newproperty(:enabled) do
    desc 'whether or not power should be enabled'
    newvalues(:true, :false)
    defaultto(:true)
  end



end
