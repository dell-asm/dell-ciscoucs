Puppet::Type.newtype(:ciscoucs_serverprofile_power) do
  @doc = 'Power on/off a server profile on cisco ucs device'
  
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end


  newparam
  
  
  newproperty(:power_state) do
    desc 'whether or not power should be enabled'
    newvalues(:on, :off)
    defaultto(:on)
  end



end
