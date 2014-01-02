Puppet::Type.newtype(:ciscoucs_updatelan_boot_order) do
  @doc = 'Clone service profile on cisco ucs device'

  ensurable do
    newvalue(:present) do
      provider.create
    end

  

    defaultto(:present)
  end

  newparam(:dn, :namevar => true) do
    puts "Name of Boot Policy";
  end
    
  newparam(:value) do
      puts "value";
    end
 
  newparam(:lanorder) do
      puts "lanorder";
end
end
