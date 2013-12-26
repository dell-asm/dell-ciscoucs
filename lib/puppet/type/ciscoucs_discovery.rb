Puppet::Type.newtype(:ciscoucs_discovery) do
  @doc = 'Discover Blade Servers on cisco ucs'
  ensurable do
    newvalue(:absent) do
      provider.create
    end
    defaultto(:absent)
  end
  
  newparam(:name, :namevar => true) do
    end
end