Puppet::Type.newtype(:ciscoucs_serviceprofile_association) do
  @doc = 'Associate service profile Associate on cisco ucs device'

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
  end

  newparam(:organization_name) do
  end

  newparam(:service_profile_name) do
  end
  
  newparam(:profile_dn) do
    defaultsto 'org-'+resource[:organization_name]+'/ls-'+resource[:service_profile_name];
  end

  newparam(:server_chesis_id) do
  end

  newparam(:server_slot) do
  end
  
  newparam(:server_dn) do
    defaultsto 'sys/'+resource[:server_chesis_id]+'/'+resource[:server_slot];
  end
  
end
