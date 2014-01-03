Puppet::Type.newtype(:ciscoucs_updatelan_boot_order) do
  @doc = 'Modify service profile boot policy order on cisco ucs device'

  ensurable do
    newvalue(:present) do
      provider.create
    end

    defaultto(:present)
  end

  newparam(:policyname, :namevar => true ) do
    desc "Boot Policy name"
    end
     
  newparam(:dn) do
    desc "Service profile dn"
    end
     
   newparam(:organization) do
      desc "Service profile org"
      end
   
   newparam(:lanorder) do
      desc "Order number of LAN"
      end
end

