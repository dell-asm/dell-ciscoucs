Puppet::Type.newtype(:ciscoucs_serviceprofile_associate) do
  @doc = 'Associate service profile on cisco ucs device'
  
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end

  newparam(:name, :namevar => true) do
     desc 'server profile name'
     newvalues(/\w/)
   end


  autorequire(:ciscoucs_serverprofile_power) do
    self[:name]
  end
end
