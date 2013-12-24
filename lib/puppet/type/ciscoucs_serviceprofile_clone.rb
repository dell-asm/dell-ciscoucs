Puppet::Type.newtype(:ciscoucs_serviceprofile_clone) do
  @doc = 'Clone service profile on cisco ucs device'
  ensurable do
    newvalue(:present) do 
      provider.create
    end

    newvalue(:absent) do
	  provider.destroy
    end

    defaultto(:present)
  end

  newparam(:clonename, :namevar => true) do
    desc "name of server profile clone"
	validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid clone server name."
      end
    end
	validate do |value|
      unless value =~ /\A[a-zA-Z0-9\d_\.\:]+\Z/
         raise ArgumentError, "%s is not a valid name." % value
      end
    end
  end

  newparam(:sourceserviceprofile) do
    desc "name of source server profile name"
	validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid source server profile name."
      end
    end
  end

 newparam(:targetorganizationname) do
    desc "name of target organization"
	validate do |value|
      if value.strip.length == 0
        raise ArgumentError, "Invalid target organization name."
      end
    end
  end

end

