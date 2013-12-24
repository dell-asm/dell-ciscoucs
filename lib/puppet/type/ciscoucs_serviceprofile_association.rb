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

  newparam(:organizationname) do
  end

  newparam(:serviceprofilename) do
  end

  newparam(:dnorganizationname) do
  end

  newparam(:dnserviceprofilename) do
  end

  newparam(:serverchesisid) do
  end

  newparam(:serverslot) do
  end

end
